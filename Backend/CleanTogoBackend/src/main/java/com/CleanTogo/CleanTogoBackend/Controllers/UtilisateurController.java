package com.CleanTogo.CleanTogoBackend.Controllers;

import com.CleanTogo.CleanTogoBackend.Entities.Utilisateur;
import com.CleanTogo.CleanTogoBackend.Services.UtilisateurService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:*")
@RestController
@RequestMapping("/utilisateurs/")

public class UtilisateurController {
    private final UtilisateurService utilisateurService;

    public UtilisateurController(UtilisateurService utilisateurService) {
        this.utilisateurService = utilisateurService;
    }

    @PostMapping("save")
    public ResponseEntity<Utilisateur> create(@RequestBody Utilisateur utilisateur) {
        Utilisateur saved = utilisateurService.save(utilisateur);
        System.out.println("Utilisateur");
        System.out.println(utilisateur);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("findAll")
    public List<Utilisateur> list() {
        return utilisateurService.findAll();
    }

    @PutMapping("update/{id}")
    public ResponseEntity<Utilisateur> update(@PathVariable("id") long id,
                                             @RequestBody Utilisateur utilisateur) {
        Utilisateur update = utilisateurService.update(utilisateur, id);
        return ResponseEntity.status(HttpStatus.CREATED).body(update);
    }

    @DeleteMapping("delete/{id}")
    public void delete(@PathVariable("id") long id) {
        utilisateurService.delete(id);
    }

    @GetMapping("findById/{id}")
    public ResponseEntity getById(@PathVariable("id") long id) {
        Utilisateur utilisateurFind = utilisateurService.findById(id);
        return ResponseEntity.status(HttpStatus.OK).body(utilisateurFind);
    }
}
