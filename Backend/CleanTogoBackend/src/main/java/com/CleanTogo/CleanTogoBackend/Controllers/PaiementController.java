package com.CleanTogo.CleanTogoBackend.Controllers;

import com.CleanTogo.CleanTogoBackend.Entities.Paiement;
import com.CleanTogo.CleanTogoBackend.Services.PaiementService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:*")
@RestController
@RequestMapping("/paiements/")

public class PaiementController {
    private final PaiementService paiementService;

    public PaiementController(PaiementService paiementService) {
        this.paiementService = paiementService;
    }

    @PostMapping("save")
    public ResponseEntity<Paiement> create(@RequestBody Paiement paiement) {
        Paiement saved = paiementService.save(paiement);
        System.out.println("Paiement");
        System.out.println(paiement);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("findAll")
    public List<Paiement> list() {
        return paiementService.findAll();
    }

    @PutMapping("update/{id}")
    public ResponseEntity<Paiement> update(@PathVariable("id") long id,
                                              @RequestBody Paiement paiement) {
        Paiement update = paiementService.update(paiement, id);
        return ResponseEntity.status(HttpStatus.CREATED).body(update);
    }

    @DeleteMapping("delete/{id}")
    public void delete(@PathVariable("id") long id) {
        paiementService.delete(id);
    }

    @GetMapping("findById/{id}")
    public ResponseEntity getById(@PathVariable("id") long id) {
        Paiement paiementFind = paiementService.findById(id);
        return ResponseEntity.status(HttpStatus.OK).body(paiementFind);
    }
}
