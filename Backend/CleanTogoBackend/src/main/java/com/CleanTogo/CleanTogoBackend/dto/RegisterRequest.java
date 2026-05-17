package com.CleanTogo.CleanTogoBackend.dto;

import com.CleanTogo.CleanTogoBackend.Entities.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RegisterRequest {
    private String nom;
    private String prenom;
    private String email;
    private String username;
    private String phone;
    private String password;
    private Role role;
    private boolean statut;
}
