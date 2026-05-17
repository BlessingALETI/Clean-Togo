package com.CleanTogo.CleanTogoBackend.Services;

import com.CleanTogo.CleanTogoBackend.Entities.Chauffeur;

import java.util.List;

public interface ChauffeurService {
    Chauffeur save (Chauffeur chauffeur);

    Chauffeur update(Chauffeur chauffeur, long id);

    List<Chauffeur> findAll();

    void delete(long id);

    Chauffeur findById(long id);
}
