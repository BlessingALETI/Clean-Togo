package com.CleanTogo.CleanTogoBackend.Controllers;

import com.CleanTogo.CleanTogoBackend.Entities.Chauffeur;
import com.CleanTogo.CleanTogoBackend.Services.ChauffeurService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:*")
@RestController
@RequestMapping("/chauffeurs/")

public class ChauffeurController {
    private final ChauffeurService chauffeurService;

    public ChauffeurController(ChauffeurService chauffeurService) {
        this.chauffeurService = chauffeurService;
    }

    @PostMapping("save")
    public ResponseEntity<Chauffeur> create(@RequestBody Chauffeur chauffeur) {
        Chauffeur saved = chauffeurService.save(chauffeur);
        System.out.println("Chauffeur");
        System.out.println(chauffeur);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("findAll")
    public List<Chauffeur> list() {
        return chauffeurService.findAll();
    }

    @PutMapping("update/{id}")
    public ResponseEntity<Chauffeur> update(@PathVariable("id") long id,
                                           @RequestBody Chauffeur chauffeur) {
        Chauffeur update = chauffeurService.update(chauffeur, id);
        return ResponseEntity.status(HttpStatus.CREATED).body(update);
    }

    @DeleteMapping("delete/{id}")
    public void delete(@PathVariable("id") long id) {
        chauffeurService.delete(id);
    }

    @GetMapping("findById/{id}")
    public ResponseEntity getById(@PathVariable("id") long id) {
        Chauffeur chauffeurFind = chauffeurService.findById(id);
        return ResponseEntity.status(HttpStatus.OK).body(chauffeurFind);
    }
}
