package com.CleanTogo.CleanTogoBackend.Controllers;

import com.CleanTogo.CleanTogoBackend.Entities.Commentaire_Reclamation;
import com.CleanTogo.CleanTogoBackend.Services.Commentaire_reclamation_Service;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:*")
@RestController
@RequestMapping("/commentaireReclamations/")

public class CommentaireReclamationController {
    private final Commentaire_reclamation_Service commentaireReclamationService;

    public CommentaireReclamationController(Commentaire_reclamation_Service commentaireReclamationService) {
        this.commentaireReclamationService = commentaireReclamationService;
    }

    @PostMapping("save")
    public ResponseEntity<Commentaire_Reclamation> create(@RequestBody Commentaire_Reclamation commentaireReclamation) {
        Commentaire_Reclamation saved = commentaireReclamationService.save(commentaireReclamation);
        System.out.println("Commentaire_Reclamation");
        System.out.println(commentaireReclamation);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("findAll")
    public List<Commentaire_Reclamation> list() {
        return commentaireReclamationService.findAll();
    }

    @PutMapping("update/{id}")
    public ResponseEntity<Commentaire_Reclamation> update(@PathVariable("id") long id,
                                                         @RequestBody Commentaire_Reclamation commentaireReclamation) {
        Commentaire_Reclamation update = commentaireReclamationService.update(commentaireReclamation, id);
        return ResponseEntity.status(HttpStatus.CREATED).body(update);
    }

    @DeleteMapping("delete/{id}")
    public void delete(@PathVariable("id") long id) {
        commentaireReclamationService.delete(id);
    }

    @GetMapping("findById/{id}")
    public ResponseEntity getById(@PathVariable("id") long id) {
        Commentaire_Reclamation commentaireReclamationFind = commentaireReclamationService.findById(id);
        return ResponseEntity.status(HttpStatus.OK).body(commentaireReclamationFind);
    }
}
