package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Entities.Chauffeur;
import com.CleanTogo.CleanTogoBackend.Entities.Role;
import com.CleanTogo.CleanTogoBackend.Services.ChauffeurService;
import com.CleanTogo.CleanTogoBackend.repositories.ChauffeurRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChauffeurServiceImp implements ChauffeurService {

    private final ChauffeurRepository chauffeurRepository;
    private final PasswordEncoder passwordEncoder;

    public ChauffeurServiceImp(ChauffeurRepository chauffeurRepository, PasswordEncoder passwordEncoder) {
        this.chauffeurRepository = chauffeurRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Chauffeur save(Chauffeur chauffeur) {
        if (chauffeur.getPassword() != null && !chauffeur.getPassword().isEmpty()) {
            chauffeur.setPassword(passwordEncoder.encode(chauffeur.getPassword()));
        }
        return this.chauffeurRepository.save(chauffeur);
    }

    @Override
    public Chauffeur update(Chauffeur chauffeur, long id) {
        Chauffeur chauffeurFind = chauffeurRepository.findById(id).orElse(null);
        if (chauffeurFind != null) {
            chauffeurFind.setNom(chauffeur.getNom());
            chauffeurFind.setPrenom(chauffeur.getPrenom());
            chauffeurFind.setPhone(chauffeur.getPhone());
            chauffeurFind.setUsername(chauffeur.getRealUsername());
            chauffeurFind.setEmail(chauffeur.getEmail());
            chauffeurFind.setRole(Role.CHAUFFEUR);

            if (chauffeur.getPassword() != null && !chauffeur.getPassword().isEmpty()) {
                chauffeurFind.setPassword(passwordEncoder.encode(chauffeur.getPassword()));
            }
            return chauffeurRepository.save(chauffeurFind);
        }
        return null;
    }

    @Override
    public List<Chauffeur> findAll() {
        return chauffeurRepository.findAll();
    }

    @Override
    public void delete(long id) {
        chauffeurRepository.deleteById(id);
    }

    @Override
    public Chauffeur findById(long id) {
        return chauffeurRepository.findById(id).orElse(null);
    }
}
