package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Entities.Course;
import com.CleanTogo.CleanTogoBackend.Services.CourseService;
import com.CleanTogo.CleanTogoBackend.repositories.CourseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CourseServiceImp implements CourseService {

    private final CourseRepository courseRepository;

    @Override
    public Course save(Course course) {
        return courseRepository.save(course);
    }

    @Override
    public Course update(Course course, long id) {
        Course courseFind = courseRepository.findById(id).orElse(null);
        if (courseFind != null) {
            courseFind.setDate_passage(course.getDate_passage());
            courseFind.setChauffeur(course.getChauffeur());
            return courseRepository.save(courseFind);
        }
        return null;
    }

    @Override
    public List<Course> findAll() {
        return courseRepository.findAll();
    }

    @Override
    public void delete(long id) {
        Course courseFind = courseRepository.findById(id).orElse(null);
        if (courseFind != null) {
            courseRepository.deleteById(courseFind.getId());
        }
    }

    @Override
    public Course findById(long id) {
        return courseRepository.findById(id).orElse(null);
    }
}
