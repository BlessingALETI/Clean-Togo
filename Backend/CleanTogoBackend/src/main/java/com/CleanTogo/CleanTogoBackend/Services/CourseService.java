package com.CleanTogo.CleanTogoBackend.Services;

import com.CleanTogo.CleanTogoBackend.Entities.Course;

import java.util.List;

public interface CourseService {
    Course save (Course course);

    Course update(Course course, long id);

    List<Course> findAll();

    void delete(long id);

    Course findById(long id);
}
