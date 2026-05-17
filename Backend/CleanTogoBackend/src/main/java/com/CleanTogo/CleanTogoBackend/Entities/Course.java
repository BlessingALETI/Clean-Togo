package com.CleanTogo.CleanTogoBackend.Entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.util.List;

@Entity
@Table(name = "Courses")
@Data
@NoArgsConstructor
@AllArgsConstructor

public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "date_passage")
    private Date date_passage;

    @ManyToOne
    @JoinColumn(name="chauffeur_id")
    @JsonIgnore
    private Chauffeur chauffeur;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL)
    private List<Secteur> secteurs;

}
