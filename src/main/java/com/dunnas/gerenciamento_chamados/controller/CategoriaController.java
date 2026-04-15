package com.dunnas.gerenciamento_chamados.controller;

import com.dunnas.gerenciamento_chamados.model.Categoria;
import com.dunnas.gerenciamento_chamados.service.CategoriaService;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/categorias")
@RequiredArgsConstructor
public class CategoriaController {

    private final CategoriaService categoriaService;

    @GetMapping("/novo")
    public String novaCategoria(Model model) {
        model.addAttribute("categoria", new Categoria());
        return "cadastro-categoria"; // Crie um JSP simples para isso
    }


    @PostMapping("/salvar")
    public String salvar(@ModelAttribute("categoria") Categoria categoria, RedirectAttributes attr) {
        try {
            categoriaService.salvar(categoria);
            attr.addFlashAttribute("mensagemSucesso", "Categoria salva com sucesso!");
        } catch (RuntimeException e) {
            attr.addFlashAttribute("mensagemErro", "Erro: " + e.getMessage());
            return "redirect:/categorias/novo";
        }
        return "redirect:/colaboradores/novo";
    }
}
