package com.CleanTogo.CleanTogoBackend.Controllers;

import com.CleanTogo.CleanTogoBackend.Entities.Client;
import com.CleanTogo.CleanTogoBackend.Services.ClientService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:*")
@RestController
@RequestMapping("/clients/")

public class ClientController {
    private final ClientService clientService;

    public ClientController(ClientService clientService) {
        this.clientService = clientService;
    }

    @PostMapping("save")
    public ResponseEntity<Client> create(@RequestBody Client client) {
        Client saved = clientService.save(client);
        System.out.println("Client");
        System.out.println(client);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("findAll")
    public List<Client> list() {
        return clientService.findAll();
    }


    @PutMapping("update/{id}")
    public  ResponseEntity<Client> update(@PathVariable ("id") long id,
                                         @RequestBody Client client)
    {
        Client update = clientService.update(client,id);
        return ResponseEntity.status(HttpStatus.CREATED).body(update);

    }
    @DeleteMapping("delete/{id}")
    public void delete(@PathVariable ("id") long id){
        clientService.delete(id);
    }

    @GetMapping("findById/{id}")
    public ResponseEntity getById(@PathVariable ("id") long id){
        Client clientFind = clientService.findById(id);
        return ResponseEntity.status(HttpStatus.OK).body(clientFind);
    }
}
