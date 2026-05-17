package com.CleanTogo.CleanTogoBackend.Controllers;

import com.CleanTogo.CleanTogoBackend.Entities.Secteur;
import com.CleanTogo.CleanTogoBackend.Services.SecteurService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:*")
@RestController
@RequestMapping("/secteurs/")

public class SecteurController {
    private final SecteurService secteurService;

    public SecteurController(SecteurService secteurService) {
        this.secteurService = secteurService;
    }

    @PostMapping("save")
    public ResponseEntity<Secteur> create(@RequestBody Secteur secteur) {
        Secteur saved = secteurService.save(secteur);
        System.out.println("Secteur");
        System.out.println(secteur);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("findAll")
    public List<Secteur> list() {
        return secteurService.findAll();
    }

    @PutMapping("update/{id}")
    public ResponseEntity<Secteur> update(@PathVariable("id") long id,
                                         @RequestBody Secteur secteur) {
        Secteur update = secteurService.update(secteur, id);
        return ResponseEntity.status(HttpStatus.CREATED).body(update);
    }

    @DeleteMapping("delete/{id}")
    public void delete(@PathVariable("id") long id) {
        secteurService.delete(id);
    }

    @GetMapping("findById/{id}")
    public ResponseEntity getById(@PathVariable("id") long id) {
        Secteur secteurFind = secteurService.findById(id);
        return ResponseEntity.status(HttpStatus.OK).body(secteurFind);
    }
}
