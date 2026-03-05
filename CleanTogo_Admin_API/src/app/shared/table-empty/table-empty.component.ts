import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-table-empty',
  templateUrl: './table-empty.component.html',
  styleUrls: ['./table-empty.component.scss']
})
export class TableEmptyComponent {
  @Input() message = 'Aucune donnée.';
}
