package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Entities.Paiement;
import com.CleanTogo.CleanTogoBackend.Services.PaiementService;
import com.CleanTogo.CleanTogoBackend.repositories.PaiementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PaiementServiceImp implements PaiementService {

    private final PaiementRepository paiementRepository;

    @Override
    public Paiement save(Paiement paiement) {
        return paiementRepository.save(paiement);
    }

    @Override
    public Paiement update(Paiement paiement, long id) {
        Paiement paiementFind = paiementRepository.findById(id).orElse(null);
        if (paiementFind != null) {
            paiementFind.setMontant(paiement.getMontant());
            paiementFind.setNomModePaiement(paiement.getNomModePaiement());
            paiementFind.setNumero(paiement.getNumero());
            paiementFind.setDateVersement(paiement.getDateVersement());
            return paiementRepository.save(paiementFind);
        }
        return null;
    }

    @Override
    public List<Paiement> findAll() {
        return paiementRepository.findAll();
    }

    @Override
    public void delete(long id) {
        Paiement paiementFind = paiementRepository.findById(id).orElse(null);
        if (paiementFind != null) {
            paiementRepository.deleteById(paiementFind.getId());
        }
    }

    @Override
    public Paiement findById(long id) {
        return paiementRepository.findById(id).orElse(null);
    }
}
