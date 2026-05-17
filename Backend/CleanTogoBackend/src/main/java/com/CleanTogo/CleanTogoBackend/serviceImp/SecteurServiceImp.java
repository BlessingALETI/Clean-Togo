package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Entities.Client;
import com.CleanTogo.CleanTogoBackend.Entities.Secteur;
import com.CleanTogo.CleanTogoBackend.Services.SecteurService;
import com.CleanTogo.CleanTogoBackend.repositories.SecteurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SecteurServiceImp implements SecteurService {

    private final SecteurRepository secteurRepository;

    @Override
    public Secteur save(Secteur secteur) {
        return secteurRepository.save(secteur);
    }

    @Override
    public Secteur update(Secteur secteur, long id) {
        Secteur secteurFind = secteurRepository.findById(id).orElse(null);
        if (secteurFind != null) {
            secteurFind.setNom_secteur(secteur.getNom_secteur());
            return secteurRepository.save(secteurFind);
        }
        return null;
    }


    @Override
    public List<Secteur> findAll() {
        return secteurRepository.findAll();
    }

    @Override
    public void delete(long id) {
        Secteur secteurFind = secteurRepository.findById(id).orElse(null);
        if (secteurFind != null) {
            secteurRepository.deleteById(secteurFind.getId());
        }
    }

    @Override
    public Secteur findById(long id) {
        return secteurRepository.findById(id).orElse(null);
    }
}
