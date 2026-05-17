package com.CleanTogo.CleanTogoBackend.Services;

import com.CleanTogo.CleanTogoBackend.Entities.Secteur;

import java.util.List;

public interface SecteurService {
    Secteur save (Secteur secteur);

    Secteur update(Secteur secteur, long id);

    List<Secteur> findAll();

    void delete(long id);

    Secteur findById(long id);
}
