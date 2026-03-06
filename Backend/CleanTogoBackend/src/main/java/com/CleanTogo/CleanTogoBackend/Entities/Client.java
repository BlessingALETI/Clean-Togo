package com.CleanTogo.CleanTogoBackend.Entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@DiscriminatorValue("CLIENT")

public class Client extends Utilisateur {

    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    private List<Foyer> foyers;
}
