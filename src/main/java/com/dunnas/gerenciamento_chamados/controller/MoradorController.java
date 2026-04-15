package com.dunnas.gerenciamento_chamados.controller;

import com.dunnas.gerenciamento_chamados.model.Morador;
import com.dunnas.gerenciamento_chamados.service.MoradorService;
import com.dunnas.gerenciamento_chamados.service.UnidadeService; // Você vai precisar desse!
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/moradores")
@RequiredArgsConstructor
public class MoradorController {

    private final MoradorService moradorService;
    private final UnidadeService unidadeService;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("moradores", moradorService.listarTodos());
        return "lista-moradores";
    }

    @GetMapping("/novo")
    public String exibirFormulario(Model model) {
        model.addAttribute("morador", new Morador());
        // AJUSTE: Mudei para "listaUnidades" para bater com o JSP
        model.addAttribute("listaUnidades", unidadeService.listarTodas());
        return "cadastro-morador";
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute("morador") Morador morador, RedirectAttributes attributes) {
        try {
            moradorService.salvar(morador);
            // AJUSTE: Mensagem genérica que serve para os dois casos
            attributes.addFlashAttribute("mensagemSucesso", "Dados salvos com sucesso!");
            return "redirect:/moradores";
        } catch (Exception e) {
            attributes.addFlashAttribute("mensagemErro", "Erro ao processar: " + e.getMessage());
            // Se for erro na edição, o ideal é voltar para a tela de edição
            if (morador.getId() != null) {
                return "redirect:/moradores/editar/" + morador.getId();
            }
            return "redirect:/moradores/novo";
        }
    }

    @GetMapping("/editar/{id}")
    public String exibirEdicao(@PathVariable Long id, Model model) {
        Morador morador = moradorService.buscarPorId(id);
        model.addAttribute("morador", morador);
        // Aqui já estava certo: "listaUnidades"
        model.addAttribute("listaUnidades", unidadeService.listarTodas());
        return "cadastro-morador";
    }

    @GetMapping("/excluir/{id}")
    public String excluir(@PathVariable Long id, RedirectAttributes attr) {
        try {
            moradorService.deletar(id);
            attr.addFlashAttribute("mensagemSucesso", "Morador removido com sucesso!");
        } catch (Exception e) {
            // Em sistemas reais, o banco impede excluir quem tem chamados (FK)
            attr.addFlashAttribute("mensagemErro", "Não foi possível excluir o morador.");
        }
        return "redirect:/moradores";
    }
}