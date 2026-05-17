package com.CleanTogo.CleanTogoBackend.Services;

import com.CleanTogo.CleanTogoBackend.Entities.Administrateur;

import java.util.List;

public interface AdministrateurService {
    Administrateur save (Administrateur administrateur);

    Administrateur update(Administrateur administrateur, long id);

    List<Administrateur> findAll();

    void delete(long id);

    Administrateur findById(long id);
}
