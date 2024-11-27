import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-rapport-sub',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './rapport-sub.component.html',
  styleUrl: './rapport-sub.component.scss'
})
export class RapportSubComponent {

  reports = [
    { id: 1, name: 'Rapport 1', category: 'Bouteilles en stock', createdAt: new Date() },
    { id: 2, name: 'Rapport 2', category: 'Bouteilles en cours de livraison', createdAt: new Date() },
    { id: 3, name: 'Rapport 3', category: 'Bouteilles retournées', createdAt: new Date() },
    { id: 4, name: 'Rapport 4', category: 'Bouteilles livrées', createdAt: new Date() },
    { id: 5, name: 'Rapport 5', category: 'Emplisseurs', createdAt: new Date() },
    { id: 6, name: 'Rapport 6', category: 'Transporteurs', createdAt: new Date() },
    { id: 7, name: 'Rapport 7', category: 'Marketeurs', createdAt: new Date() },
    { id: 8, name: 'Rapport 8', category: 'Revendeurs', createdAt: new Date() },
    { id: 9, name: 'Rapport 9', category: 'Ménages', createdAt: new Date() },
  ];

  categories = Array.from(new Set(this.reports.map((r) => r.category)));
  selectedCategory = '';
  filteredReports = [...this.reports];

  filterReports() {
    this.filteredReports = this.selectedCategory
      ? this.reports.filter((report) => report.category === this.selectedCategory)
      : [...this.reports];
  }

  downloadReport(report: any, format: 'pdf' | 'csv') {
    const fileName = `${report.name}.${format}`;
    const blob = new Blob([`Contenu du ${report.name} en ${format}`], { type: 'text/plain' });
    const url = window.URL.createObjectURL(blob);

    const a = document.createElement('a');
    a.href = url;
    a.download = fileName;
    a.click();

    window.URL.revokeObjectURL(url);
  }

}
