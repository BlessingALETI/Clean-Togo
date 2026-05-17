package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Entities.Client;
import com.CleanTogo.CleanTogoBackend.Entities.Role;
import com.CleanTogo.CleanTogoBackend.Services.ClientService;
import com.CleanTogo.CleanTogoBackend.repositories.ClientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ClientServiceImp implements ClientService {

    private final ClientRepository clientRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public Client save(Client client) {
        if (client.getPassword() != null && !client.getPassword().isEmpty()) {
            client.setPassword(passwordEncoder.encode(client.getPassword()));
        }
        return clientRepository.save(client);
    }

    @Override
    public Client update(Client client, long id) {
        return clientRepository.findById(id).map(existingClient -> {
            existingClient.setNom(client.getNom());
            existingClient.setPrenom(client.getPrenom());
            existingClient.setPhone(client.getPhone());
            existingClient.setUsername(client.getRealUsername());
            existingClient.setEmail(client.getEmail());
            existingClient.setRole(Role.CLIENT);
            
            if (client.getPassword() != null && !client.getPassword().isEmpty()) {
                existingClient.setPassword(passwordEncoder.encode(client.getPassword()));
            }
            return clientRepository.save(existingClient);
        }).orElse(null);
    }

    @Override
    public List<Client> findAll() {
        return clientRepository.findAll();
    }

    @Override
    public void delete(long id) {
        if (clientRepository.existsById(id)) {
            clientRepository.deleteById(id);
        }
    }

    @Override
    public Client findById(long id) {
        return clientRepository.findById(id).orElse(null);
    }
}
