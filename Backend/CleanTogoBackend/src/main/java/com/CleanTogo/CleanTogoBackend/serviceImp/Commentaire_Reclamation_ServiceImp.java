package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Entities.Commentaire_Reclamation;
import com.CleanTogo.CleanTogoBackend.Services.Commentaire_reclamation_Service;
import com.CleanTogo.CleanTogoBackend.repositories.Commentaire_Reclamation_Repository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class Commentaire_Reclamation_ServiceImp implements Commentaire_reclamation_Service {

    private final Commentaire_Reclamation_Repository commentaireReclamationRepository;

    @Override
    public Commentaire_Reclamation save(Commentaire_Reclamation commentaireReclamation) {
        return commentaireReclamationRepository.save(commentaireReclamation);
    }

    @Override
    public Commentaire_Reclamation update(Commentaire_Reclamation commentaireReclamation, long id) {
        Commentaire_Reclamation commentaireReclamationFind = commentaireReclamationRepository.findById(id).orElse(null);
        if (commentaireReclamationFind != null) {
            commentaireReclamationFind.setObjet(commentaireReclamation.getObjet());
            commentaireReclamationFind.setDescription(commentaireReclamation.getDescription());
            return commentaireReclamationRepository.save(commentaireReclamationFind);
        }
        return null;
    }

    @Override
    public List<Commentaire_Reclamation> findAll() {
        return commentaireReclamationRepository.findAll();
    }

    @Override
    public void delete(long id) {
        Commentaire_Reclamation commentaireReclamationFind = commentaireReclamationRepository.findById(id).orElse(null);
        if (commentaireReclamationFind != null) {
            commentaireReclamationRepository.deleteById(commentaireReclamationFind.getId());
        }
    }

    @Override
    public Commentaire_Reclamation findById(long id) {
        return commentaireReclamationRepository.findById(id).orElse(null);
    }
}
