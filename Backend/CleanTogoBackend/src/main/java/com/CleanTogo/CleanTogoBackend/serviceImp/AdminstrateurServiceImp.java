package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Entities.Administrateur;
import com.CleanTogo.CleanTogoBackend.Entities.Role;
import com.CleanTogo.CleanTogoBackend.Services.AdministrateurService;
import com.CleanTogo.CleanTogoBackend.repositories.AdministrateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminstrateurServiceImp implements AdministrateurService {

    private final AdministrateurRepository administrateurRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public Administrateur save(Administrateur administrateur) {
        if (administrateur.getPassword() != null && !administrateur.getPassword().isEmpty()) {
            administrateur.setPassword(passwordEncoder.encode(administrateur.getPassword()));
        }
        return administrateurRepository.save(administrateur);
    }

    @Override
    public Administrateur update(Administrateur administrateur, long id) {
        return administrateurRepository.findById(id).map(existingAdmin -> {
            existingAdmin.setNom(administrateur.getNom());
            existingAdmin.setPrenom(administrateur.getPrenom());
            existingAdmin.setPhone(administrateur.getPhone());
            existingAdmin.setUsername(administrateur.getRealUsername());
            existingAdmin.setEmail(administrateur.getEmail());
            existingAdmin.setRole(Role.ADMIN);
            if (administrateur.getPassword() != null && !administrateur.getPassword().isEmpty()) {
                existingAdmin.setPassword(passwordEncoder.encode(administrateur.getPassword()));
            }
            return administrateurRepository.save(existingAdmin);
        }).orElse(null);
    }

    @Override
    public List<Administrateur> findAll() {
        return administrateurRepository.findAll();
    }

    @Override
    public void delete(long id) {
        if (administrateurRepository.existsById(id)) {
            administrateurRepository.deleteById(id);
        }
    }

    @Override
    public Administrateur findById(long id) {
        return administrateurRepository.findById(id).orElse(null);
    }
}
