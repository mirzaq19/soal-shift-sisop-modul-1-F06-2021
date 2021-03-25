BEGIN { FS = "\t" ;}
{ temppp = ($21/($18-$21))*100;
  if(maxpp<temppp) {
    maxpp = temppp;
    maxrow = $1
  }
  if(maxpp == temppp) {
    if(maxrow<$1) { 
      maxrow = $1;
    }
  }
}
/2017/ {
  samename = 0;
  for(itr = 0; itr < jml2017 ; itr++){
    if(custname[itr] == $7) samename = 1;
  }
  if(samename == 0) custname[jml2017++] = $7;
}
/Home Office/ { homof++ }
/Corporate/ { corp++ }
/Consumer/ { consu++ }

/Central/ { central += $21 }
/East/ { east += $21 }
/South/ { south += $21 }
/West/ { west += $21 }


END { 
   printf("\nTransaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%%\n\n",maxrow,maxpp);
   
   printf("Daftar nama customer di Albuquerque pada tahun 2017 antara lain: \n");
  for(itr = 0 ; itr < jml2017; itr++) printf("%s\n",custname[itr]);
  printf("\n");

  if(homof < corp){
    if(homof < consu) { minseg = "Home Office"; mintotseg = homof; }
    else {minseg = "Customer"; mintotseg = consu; }
  }
  else{
    if(corp < consu) { minseg = "Corporate"; mintotseg = corp; }
    else {minseg = "Customer"; mintotseg = consu; }
  }
  
  printf("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n",minseg,mintotseg);
  
  if(central < east){
    if(central < south){
      if(central < west){ minregion = "Central"; minprofregion = central; }
      else { minregion = "West"; minprofregion = west; }
    }
    else {
      if(south < west) { minregion = "South"; minprofregion = south; }
      else { minregion = "West"; minprofregion = west; }
    }
  }
  else {
    if(east < south) {
      if(east < west) { minregion = "East"; minprofregion = east; }
      else { minregion = "West"; minprofregion = west; }
    }
    else {
      if(south < west) { minregion = "South"; minprofregion = south; }
      else { minregion = "West"; minprofregion = west; }
    }
  }
  printf("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %f",minregion,minprofregion);
}

