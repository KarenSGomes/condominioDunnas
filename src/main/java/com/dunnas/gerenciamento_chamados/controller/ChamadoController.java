package com.dunnas.gerenciamento_chamados.controller;

import com.dunnas.gerenciamento_chamados.model.*;
import com.dunnas.gerenciamento_chamados.service.*;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/chamados")
@RequiredArgsConstructor
public class ChamadoController {

    private final ChamadoService chamadoService;
    private final MoradorService moradorService;
    private final CategoriaService categoriaService;
    private final UnidadeService unidadeService;
    private final ColaboradorService colaboradorService;
    private final AdministradorService administradorService;


    @PostMapping("/salvar")
    public String salvar(@ModelAttribute("chamado") Chamado chamado,
                         @RequestParam(value = "file", required = false) MultipartFile file,
                         HttpSession session,
                         RedirectAttributes attr) {
        Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
        if (logado == null) return "redirect:/login";

        try {
            boolean isNovo = (chamado.getId() == null);
            if (logado instanceof Morador && isNovo) {
                chamado.setMorador((Morador) logado);
            }

            chamadoService.salvar(chamado, file);

            attr.addFlashAttribute("mensagemSucesso", isNovo ? "Chamado registrado com sucesso!" : "Chamado atualizado!");
            return (logado instanceof Morador) ? "redirect:/chamados/dashboard-morador" : "redirect:/chamados";

        } catch (Exception e) {
            e.printStackTrace();
            attr.addFlashAttribute("mensagemErro", "Erro ao processar chamado: " + e.getMessage());
            return "redirect:/chamados";
        }
    }

    @GetMapping("/editar/{id}")
    public String exibirEdicao(@PathVariable Long id, Model model, HttpSession session) {
        Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
        if (logado == null) return "redirect:/login";

        Chamado chamado = chamadoService.buscarPorId(id);
        String perfil = (String) session.getAttribute("perfil");

        // Regra de Segurança: Morador só edita o próprio chamado e se ainda estiver ABERTO
        if ("MORADOR".equals(perfil)) {
            if (!chamado.getMorador().getId().equals(logado.getId()) || !"ABERTO".equals(chamado.getStatus())) {
                return "redirect:/chamados?mensagemErro=Edicao+nao+permitida";
            }
            model.addAttribute("unidadesDoMorador", moradorService.buscarPorId(logado.getId()).getUnidades());
        } else if ("ADMIN".equals(perfil)) {
            model.addAttribute("moradores", moradorService.listarTodos());
            model.addAttribute("unidades", unidadeService.listarTodas());
        }

        model.addAttribute("chamado", chamado);
        model.addAttribute("categorias", categoriaService.listarTodas());
        model.addAttribute("usuarioLogado", logado);
        model.addAttribute("perfil", perfil);

        return "novo-chamado-morador";
    }

    @GetMapping("/detalhes/{id}")
    public String verDetalhes(@PathVariable Long id, Model model, HttpSession session) {
        Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
        if (logado == null) return "redirect:/login";

        model.addAttribute("chamado", chamadoService.buscarPorId(id));
        model.addAttribute("usuarioLogado", logado);
        model.addAttribute("perfil", session.getAttribute("perfil"));
        return "detalhes-chamado";
    }

    @GetMapping("/atender/{id}")
    public String atender(@PathVariable Long id, RedirectAttributes attr) {
        chamadoService.iniciarAtendimento(id);
        attr.addFlashAttribute("mensagemSucesso", "Atendimento iniciado!");
        return "redirect:/chamados/detalhes/" + id;
    }

    @GetMapping("/concluir/{id}")
    public String concluir(@PathVariable Long id, RedirectAttributes attr) {
        chamadoService.concluirChamado(id);
        attr.addFlashAttribute("mensagemSucesso", "Chamado finalizado!");
        return "redirect:/chamados/detalhes/" + id;
    }

    @GetMapping("/dashboard-morador")
    public String dashboardMorador(HttpSession session, Model model) {
        Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
        if (!(logado instanceof Morador)) return "redirect:/login";

        List<Chamado> meusChamados = chamadoService.listarPorEscopo(logado);
        model.addAttribute("morador", logado);
        model.addAttribute("meusChamados", meusChamados);
        model.addAttribute("qtdAbertos", meusChamados.stream().filter(c -> "ABERTO".equals(c.getStatus())).count());
        model.addAttribute("qtdAndamento", meusChamados.stream().filter(c -> c.getStatus().contains("ATENDIMENTO") || c.getStatus().contains("ANDAMENTO")).count());
        model.addAttribute("perfil", "MORADOR");
        model.addAttribute("usuarioLogado", logado);
        return "dashboard-morador";
    }

    @GetMapping("/dashboard-colaborador")
    public String dashboardColaborador(HttpSession session, Model model) {
        Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
        if (!(logado instanceof Colaborador)) return "redirect:/login";

        Colaborador colab = colaboradorService.buscarPorId(logado.getId());
        List<Chamado> chamadosEscopo = chamadoService.listarPorEscopo(colab);

        model.addAttribute("colaborador", colab);
        model.addAttribute("chamados", chamadosEscopo);
        model.addAttribute("qtdNovos", chamadosEscopo.stream().filter(c -> "ABERTO".equals(c.getStatus())).count());
        model.addAttribute("perfil", "COLABORADOR");
        model.addAttribute("usuarioLogado", colab);
        return "dashboard-colaborador";
    }

    @GetMapping("/novo")
    public String exibirFormularioMorador(Model model, HttpSession session) {
        Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
        if (!(logado instanceof Morador)) return "redirect:/login";

        Morador morador = moradorService.buscarPorId(logado.getId());
        model.addAttribute("chamado", new Chamado());
        model.addAttribute("unidadesDoMorador", morador.getUnidades());
        model.addAttribute("categorias", categoriaService.listarTodas());
        model.addAttribute("usuarioLogado", morador);
        model.addAttribute("perfil", "MORADOR");
        return "novo-chamado-morador";
    }

    @GetMapping("/novo/admin")
    public String exibirFormularioAdmin(Model model, HttpSession session) {
        model.addAttribute("chamado", new Chamado());
        model.addAttribute("moradores", moradorService.listarTodos());
        model.addAttribute("unidades", unidadeService.listarTodas());
        model.addAttribute("categorias", categoriaService.listarTodas());
        model.addAttribute("usuarioLogado", session.getAttribute("usuarioLogado"));
        model.addAttribute("perfil", "ADMIN");
        return "abrir-chamado-admin";
    }

    @PostMapping("/comentar")
    public String adicionarComentario(@RequestParam Long chamadoId,
                                      @RequestParam String texto,
                                      HttpSession session,
                                      RedirectAttributes attr) {
        Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
        if (logado == null) return "redirect:/login";

        Chamado chamado = chamadoService.buscarPorId(chamadoId);
        String perfil = (String) session.getAttribute("perfil");

        // REQUISITO DE SEGURANÇA: Validar escopo do morador
        if ("MORADOR".equals(perfil)) {
            // Verifica se o chamado pertence ao morador logado
            if (!chamado.getMorador().getId().equals(logado.getId())) {
                attr.addFlashAttribute("mensagemErro", "Ação não permitida: Este chamado não pertence a você.");
                return "redirect:/chamados";
            }
        }
        // Adicione aqui lógica para Colaborador se ele tiver categorias específicas,
        // mas geralmente colaboradores podem comentar em tudo que visualizam.

        Comentario com = new Comentario();
        com.setTexto(texto);
        com.setAutor(logado);
        com.setChamado(chamado);
        com.setDataCriacao(LocalDateTime.now()); // Garante a data atual

        chamadoService.salvarComentario(com);

        return "redirect:/chamados/detalhes/" + chamadoId;
    }

    @GetMapping("/excluir/{id}")
    public String excluir(@PathVariable Long id, RedirectAttributes attr) {
        chamadoService.excluir(id);
        attr.addFlashAttribute("mensagemSucesso", "Chamado removido!");
        return "redirect:/chamados";
    }

    // DEIXE APENAS ESTE MÉTODO LISTAR NO SEU CONTROLLER:
    @GetMapping
    public String listar(@RequestParam(required = false) Long id,
                         @RequestParam(required = false) String status,
                         Model model, HttpSession session) {
        Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
        if (logado == null) return "redirect:/login";

        Usuario logadoCompleto = logado;
        if (logado instanceof Colaborador) {
            logadoCompleto = colaboradorService.buscarPorId(logado.getId());
        } else if (logado instanceof Morador) {
            logadoCompleto = moradorService.buscarPorId(logado.getId());
        } else if (logado instanceof Administrador) {
            logadoCompleto = administradorService.buscarPorId(logado.getId());
        }

        // Chama o service usando os filtros (id e status)
        model.addAttribute("chamados", chamadoService.listarComFiltros(logadoCompleto, id, status));
        model.addAttribute("usuarioLogado", logadoCompleto);
        model.addAttribute("perfil", session.getAttribute("perfil"));

        return "lista-chamados";
    }
}