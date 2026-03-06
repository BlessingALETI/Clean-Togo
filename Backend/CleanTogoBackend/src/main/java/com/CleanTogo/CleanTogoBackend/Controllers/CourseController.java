package com.CleanTogo.CleanTogoBackend.Controllers;

import com.CleanTogo.CleanTogoBackend.Entities.Course;
import com.CleanTogo.CleanTogoBackend.Services.CourseService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:*")
@RestController
@RequestMapping("/courses/")

public class CourseController {
    private final CourseService courseService;

    public CourseController(CourseService courseService) {
        this.courseService = courseService;
    }

    @PostMapping("save")
    public ResponseEntity<Course> create(@RequestBody Course course) {
        Course saved = courseService.save(course);
        System.out.println("Course");
        System.out.println(course);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("findAll")
    public List<Course> list() {
        return courseService.findAll();
    }

    @PutMapping("update/{id}")
    public ResponseEntity<Course> update(@PathVariable("id") long id,
                                         @RequestBody Course course) {
        Course update = courseService.update(course, id);
        return ResponseEntity.status(HttpStatus.CREATED).body(update);
    }

    @DeleteMapping("delete/{id}")
    public void delete(@PathVariable("id") long id) {
        courseService.delete(id);
    }

    @GetMapping("findById/{id}")
    public ResponseEntity getById(@PathVariable("id") long id) {
        Course courseFind = courseService.findById(id);
        return ResponseEntity.status(HttpStatus.OK).body(courseFind);
    }
}
