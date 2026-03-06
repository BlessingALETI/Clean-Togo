package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Entities.Utilisateur;
import com.CleanTogo.CleanTogoBackend.Services.UtilisateurService;
import com.CleanTogo.CleanTogoBackend.repositories.UtilisateurRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UtilisateurServiceImp implements UtilisateurService {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder;

    public UtilisateurServiceImp(UtilisateurRepository utilisateurRepository, PasswordEncoder passwordEncoder) {
        this.utilisateurRepository = utilisateurRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Utilisateur save(Utilisateur utilisateur) {
        if (utilisateur.getPassword() != null && !utilisateur.getPassword().isEmpty()) {
            utilisateur.setPassword(passwordEncoder.encode(utilisateur.getPassword()));
        }
        return utilisateurRepository.save(utilisateur);
    }

    @Override
    public Utilisateur update(Utilisateur utilisateur, long id) {
        Utilisateur utilisateurFind = utilisateurRepository.findById(id).orElse(null);
        if (utilisateurFind != null) {
            utilisateurFind.setNom(utilisateur.getNom());
            utilisateurFind.setPrenom(utilisateur.getPrenom());
            utilisateurFind.setEmail(utilisateur.getEmail());
            utilisateurFind.setUsername(utilisateur.getRealUsername());
            utilisateurFind.setPhone(utilisateur.getPhone());
            utilisateurFind.setRole(utilisateur.getRole());
            if (utilisateur.getPassword() != null && !utilisateur.getPassword().isEmpty()) {
                utilisateurFind.setPassword(passwordEncoder.encode(utilisateur.getPassword()));
            }
            return utilisateurRepository.save(utilisateurFind);
        }
        return null;
    }

    @Override
    public List<Utilisateur> findAll() {
        return utilisateurRepository.findAll();
    }

    @Override
    public void delete(long id) {
        Utilisateur utilisateurFind = utilisateurRepository.findById(id).orElse(null);
        if (utilisateurFind != null) {
            utilisateurRepository.deleteById(utilisateurFind.getId());
        }
    }

    @Override
    public Utilisateur findById(long id) {
        return utilisateurRepository.findById(id).orElse(null);
    }
}
