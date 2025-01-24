// enum FishboneType {
//   normal,
//   antiPersonal,
//   antiTank,
//   fragmentation,
// }

enum  FishboneType{
    // ------------- strip
    strip_anti_personal,
    strip_anti_tank,
    strip_anti_fragmentation,
// ------------------ row
// single
     row_singlerow_anti_personal,
     row_singlerow_anti_fragmentation,


    //  double
     row_doublerow_anti_personal,
     row_doublerow_anti_fragmentation,

// ------------------ axial
// single
     axial_singlerow_anti_personal,
     axial_singlerow_anti_fragmentation,


    //  double
     axial_doublerow_anti_personal,
    axial_doublerow_anti_fragmentation,



}


enum FishboneSection {
  strip,      // For normal, antiPersonal, antiTank, fragmentation
  row,    // For single, double, tripple
  axial    // For shubham, sarvottam, ashish, rahul
}

// Create mapping from FishboneType to FishboneSection
Map<FishboneSection, List<FishboneType>> sectionMapping = {
  FishboneSection.strip: [
    FishboneType.strip_anti_tank,
    FishboneType.strip_anti_fragmentation,
    FishboneType.strip_anti_personal,
    // FishboneType.fragmentation,
  ],
  FishboneSection.row: [
    FishboneType.row_singlerow_anti_personal,
    FishboneType.row_singlerow_anti_fragmentation,
    FishboneType.row_doublerow_anti_personal,
    FishboneType.row_doublerow_anti_fragmentation,
  ],
  FishboneSection.axial: [
    FishboneType.axial_singlerow_anti_personal,
    FishboneType.axial_singlerow_anti_fragmentation,
    FishboneType.axial_doublerow_anti_personal,
    FishboneType.axial_doublerow_anti_fragmentation,
  ],
};

// Add section titles
Map<FishboneSection, String> sectionTitles = {
  FishboneSection.strip: 'Strip',
  FishboneSection.row: 'Row',
  FishboneSection.axial: 'Axial'
};

// Add section titles
Map<FishboneType, String> fishboneTitle = {
  FishboneType.strip_anti_personal: 'Strip Anti Personal',
  FishboneType.strip_anti_tank: 'Strip Anti Tank',
  FishboneType.strip_anti_fragmentation: 'String Anti Fragmentation',


   FishboneType.row_singlerow_anti_personal : 'Single Row Anti Personal ',
    FishboneType.row_singlerow_anti_fragmentation : 'Single Row Anti Fragmentation',
    FishboneType.row_doublerow_anti_personal : 'Double Row Anti Personal',
    FishboneType.row_doublerow_anti_fragmentation : 'Double Row Anti Fragmentation',


    FishboneType.axial_singlerow_anti_personal : 'Single Axial Anti Fragmentation',
    FishboneType.axial_singlerow_anti_fragmentation : 'Single Axial Anti Fragmentation',
    FishboneType.axial_doublerow_anti_personal : 'Double Axial Anti Fragmentation',
    FishboneType.axial_doublerow_anti_fragmentation : 'Double Axial Anti Fragmentation',
}; 