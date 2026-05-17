package com.CleanTogo.CleanTogoBackend.Services;

import com.CleanTogo.CleanTogoBackend.Entities.Commentaire_Reclamation;

import java.util.List;

public interface Commentaire_reclamation_Service {
    Commentaire_Reclamation save (Commentaire_Reclamation commentaire_reclamation);

    Commentaire_Reclamation update(Commentaire_Reclamation commentaire_reclamation, long id);

    List<Commentaire_Reclamation> findAll();

    void delete(long id);

    Commentaire_Reclamation findById(long id);
}
