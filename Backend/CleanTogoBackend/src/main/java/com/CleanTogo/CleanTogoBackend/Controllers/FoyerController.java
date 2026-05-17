package com.CleanTogo.CleanTogoBackend.Controllers;

import com.CleanTogo.CleanTogoBackend.Entities.Foyer;
import com.CleanTogo.CleanTogoBackend.Services.FoyerService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:*")
@RestController
@RequestMapping("/foyers/")

public class FoyerController {
    private final FoyerService foyerService;

    public FoyerController(FoyerService foyerService) {
        this.foyerService = foyerService;
    }

    @PostMapping("save")
    public ResponseEntity<Foyer> create(@RequestBody Foyer foyer) {
        Foyer saved = foyerService.save(foyer);
        System.out.println("Foyer");
        System.out.println(foyer);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("findAll")
    public List<Foyer> list() {
        return foyerService.findAll();
    }

    @PutMapping("update/{id}")
    public ResponseEntity<Foyer> update(@PathVariable("id") long id,
                                        @RequestBody Foyer foyer) {
        Foyer update = foyerService.update(foyer, id);
        return ResponseEntity.status(HttpStatus.CREATED).body(update);
    }

    @DeleteMapping("delete/{id}")
    public void delete(@PathVariable("id") long id) {
        foyerService.delete(id);
    }

    @GetMapping("findById/{id}")
    public ResponseEntity getById(@PathVariable("id") long id) {
        Foyer foyerFind = foyerService.findById(id);
        return ResponseEntity.status(HttpStatus.OK).body(foyerFind);
    }
}
