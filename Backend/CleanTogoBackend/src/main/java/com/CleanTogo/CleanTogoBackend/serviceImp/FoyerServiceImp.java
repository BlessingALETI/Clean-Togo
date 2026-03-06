package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Entities.Foyer;
import com.CleanTogo.CleanTogoBackend.Services.FoyerService;
import com.CleanTogo.CleanTogoBackend.repositories.FoyerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FoyerServiceImp implements FoyerService {

    private final FoyerRepository foyerRepository;

    @Override
    public Foyer save(Foyer foyer) {

        return foyerRepository.save(foyer);
    }

    @Override
    public Foyer update(Foyer foyer, long id) {
        Foyer foyerFind = foyerRepository.findById(id).orElse(null);
        if (foyerFind != null) {
            foyerFind.setAdresse(foyer.getAdresse());
            return foyerRepository.save(foyerFind);
        }
        return null;
    }

    @Override
    public List<Foyer> findAll() {
        return foyerRepository.findAll();
    }

    @Override
    public void delete(long id) {
        Foyer foyerFind = foyerRepository.findById(id).orElse(null);
        if (foyerFind != null) {
            foyerRepository.deleteById(foyerFind.getId());
        }
    }

    @Override
    public Foyer findById(long id) {
        return foyerRepository.findById(id).orElse(null);
    }
}
