package com.CleanTogo.CleanTogoBackend.Services;

import com.CleanTogo.CleanTogoBackend.Entities.Foyer;

import java.util.List;

public interface FoyerService {
    Foyer save (Foyer foyer);

    Foyer update(Foyer foyer, long id);

    List<Foyer> findAll();

    void delete(long id);

    Foyer findById(long id);
}
