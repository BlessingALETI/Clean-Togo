import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TableEmptyComponent } from './tableempty.component';

describe('TableEmptyComponent', () => {
  let component: TableEmptyComponent;
  let fixture: ComponentFixture<TableEmptyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TableEmptyComponent]
    }).compileComponents();

    fixture = TestBed.createComponent(TableEmptyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
