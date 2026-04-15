package com.dunnas.gerenciamento_chamados.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Pega o caminho absoluto da pasta onde o projeto está rodando
        String rootPath = System.getProperty("user.dir");

        // Mapeia a URL /uploads/** para a pasta FÍSICA no disco
        // Assim o Spring não busca "dentro do código", mas sim "na pasta do windows"
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + rootPath + "/src/main/resources/static/uploads/");

        // Também mapeia os recursos padrão de static (css, js) para não quebrar
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
    }
}