import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-stats-card',
  templateUrl: './stats-card.component.html',
  styleUrls: ['./stats-card.component.scss']
})
export class StatsCardComponent {
  @Input() title = '';
  @Input() value = '';
  @Input() note = '';
  @Input() badgeClass = 'badge-soft-success';
}
