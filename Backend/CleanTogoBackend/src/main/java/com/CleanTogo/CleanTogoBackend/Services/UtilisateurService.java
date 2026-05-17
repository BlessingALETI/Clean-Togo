package com.CleanTogo.CleanTogoBackend.Services;

import com.CleanTogo.CleanTogoBackend.Entities.Utilisateur;

import java.util.List;

public interface UtilisateurService {
    Utilisateur save (Utilisateur utilisateur);

    Utilisateur update(Utilisateur utilisateur, long id);

    List<Utilisateur> findAll();

    void delete(long id);

    Utilisateur findById(long id);
}
