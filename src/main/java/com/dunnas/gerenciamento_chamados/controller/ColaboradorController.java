package com.dunnas.gerenciamento_chamados.controller;

import com.dunnas.gerenciamento_chamados.model.Colaborador;
import com.dunnas.gerenciamento_chamados.service.ColaboradorService;
import com.dunnas.gerenciamento_chamados.service.CategoriaService; // Adicione este import
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/colaboradores")
@RequiredArgsConstructor
public class ColaboradorController {

    private final ColaboradorService colaboradorService;
    private final CategoriaService categoriaService; // Injetado para resolver o erro 'categoriaService'

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("colaboradores", colaboradorService.listarTodos());
        return "lista-colaboradores";
    }

    @GetMapping("/novo")
    public String exibirFormulario(Model model) {
        model.addAttribute("colaborador", new Colaborador());
        model.addAttribute("todasCategorias", categoriaService.listarTodas()); // Uso do Service padronizado
        return "cadastro-colaborador";
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute("colaborador") Colaborador colaborador,
                         org.springframework.validation.BindingResult result, // ESSENCIAL
                         RedirectAttributes attributes,
                         Model model) {

        // Se houver erro de validação, o 'result' vai capturar
        if (result.hasErrors()) {
            model.addAttribute("todasCategorias", categoriaService.listarTodas());
            // Se cair aqui, a página recarrega e o form:errors que colocamos no JSP vai mostrar o erro
            return "cadastro-colaborador";
        }

        try {
            // Lógica de segurança para a senha na edição
            if (colaborador.getId() != null && (colaborador.getSenha() == null || colaborador.getSenha().isEmpty())) {
                // Se estamos editando e a senha veio vazia, pegamos a senha que já estava no banco
                Colaborador colabExistente = colaboradorService.buscarPorId(colaborador.getId());
                colaborador.setSenha(colabExistente.getSenha());
            }

            colaboradorService.salvar(colaborador);
            attributes.addFlashAttribute("mensagemSucesso", "Colaborador salvo com sucesso!");
            return "redirect:/colaboradores";

        } catch (Exception e) {
            model.addAttribute("mensagemErro", "Erro técnico: " + e.getMessage());
            model.addAttribute("todasCategorias", categoriaService.listarTodas());
            return "cadastro-colaborador";
        }
    }

    @GetMapping("/editar/{id}")
    public String exibirEdicaoColab(@PathVariable Long id, Model model) {
        // O Service já carrega as categorias (Lazy) conforme o código que fizemos antes
        Colaborador colab = colaboradorService.buscarPorId(id);
        model.addAttribute("colaborador", colab);
        model.addAttribute("todasCategorias", categoriaService.listarTodas());
        return "cadastro-colaborador";
    }

    @GetMapping("/excluir/{id}")
    public String excluirColab(@PathVariable Long id, RedirectAttributes attr) {
        // Mudado de 'excluir' para 'deletar' para bater com o seu ColaboradorService
        colaboradorService.deletar(id);
        attr.addFlashAttribute("mensagemSucesso", "Colaborador removido com sucesso.");
        return "redirect:/colaboradores";
    }
}