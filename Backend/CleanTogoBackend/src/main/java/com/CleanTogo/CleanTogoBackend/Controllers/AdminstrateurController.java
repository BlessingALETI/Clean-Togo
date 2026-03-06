package com.CleanTogo.CleanTogoBackend.Controllers;

import com.CleanTogo.CleanTogoBackend.Entities.Administrateur;
import com.CleanTogo.CleanTogoBackend.Services.AdministrateurService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:*")
@RestController
@RequestMapping("/administrateurs/")

public class AdminstrateurController {
    private final AdministrateurService AdministrateurService;

    public AdminstrateurController(AdministrateurService AdministrateurService) {
        this.AdministrateurService = AdministrateurService;
    }

    @PostMapping("save")
    public ResponseEntity<Administrateur> create(@RequestBody Administrateur Administrateur) {
        Administrateur saved = AdministrateurService.save(Administrateur);
        System.out.println("Administrateur");
        System.out.println(Administrateur);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("findAll")
    public List<Administrateur> list() {
        return AdministrateurService.findAll();
    }


    @PutMapping("update/{id}")
    public  ResponseEntity<Administrateur> update(@PathVariable ("id") long id,
                                         @RequestBody Administrateur Administrateur)
    {
        Administrateur update = AdministrateurService.update(Administrateur,id);
        return ResponseEntity.status(HttpStatus.CREATED).body(update);

    }
    @DeleteMapping("delete/{id}")
    public void delete(@PathVariable ("id") long id){
        AdministrateurService.delete(id);
    }

    @GetMapping("findById/{id}")
    public ResponseEntity getById(@PathVariable ("id") long id){
        Administrateur AdministrateurFind = AdministrateurService.findById(id);
        return ResponseEntity.status(HttpStatus.OK).body(AdministrateurFind);
    }
}
