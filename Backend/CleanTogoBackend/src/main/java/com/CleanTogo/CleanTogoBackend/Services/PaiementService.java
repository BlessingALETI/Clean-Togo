package com.CleanTogo.CleanTogoBackend.Services;

import com.CleanTogo.CleanTogoBackend.Entities.Paiement;

import java.util.List;

public interface PaiementService {
    Paiement save (Paiement paiement);

    Paiement update(Paiement paiement, long id);

    List<Paiement> findAll();

    void delete(long id);

    Paiement findById(long id);
}
