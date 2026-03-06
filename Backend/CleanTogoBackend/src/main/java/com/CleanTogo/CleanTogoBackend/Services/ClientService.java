package com.CleanTogo.CleanTogoBackend.Services;

import com.CleanTogo.CleanTogoBackend.Entities.Client;

import java.util.List;

public interface ClientService {
    Client save (Client client);

    Client update(Client client, long id);

    List<Client> findAll();

    void delete(long id);

    Client findById(long id);
}
