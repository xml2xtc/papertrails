class Jokbo {
  private String [][] csv;
  int csvWidth = 0;
  int linecount = 1;  //counting how many lines have been executed
  
  Jokbo (String filename) {
    String [] lines = loadStrings(filename);
    //calculate max width of csv file
    for (int i=0; i < lines.length; i++) {
      String [] chars=split(lines[i],'\t');
      if (chars.length>csvWidth) csvWidth=chars.length;
    }

    //create csv array based on # of rows and columns in csv file
    csv = new String [lines.length][csvWidth];

    //parse values into 2d array
    for (int i=0; i < lines.length; i++) {
      String [] temp = new String [lines.length];
      temp= split(lines[i], '\t');
      for (int j=0; j < temp.length; j++){
         csv[i][j]=temp[j];
      }
    }
    println(lines.length);
  }
  
  //Lattitude coord of the bride's clan
  public float getLat(int linenumber) {
    return Float.parseFloat(trim(csv[linenumber][5]));
  }
  
  //Longitudinal coord of the bride's clan
  public float getLong(int linenumber) {
    return Float.parseFloat(trim(csv[linenumber][6]));
  }
  
    public float getLat() {
    return Float.parseFloat(trim(csv[linecount][5]));
  }
  
  //Longitudinal coord of the bride's clan
  public float getLong() {
    return Float.parseFloat(trim(csv[linecount][6]));
  }
  
  //birth year of the bride
  public int getYear(int linenumber) {
    int year = Integer.parseInt(trim(csv[linenumber][2]));
 
    return year;
  }
  
  //The clan ID of where the bride came from
  public int getClanID(int linenumber) {
    int ID = Integer.parseInt(trim(csv[linenumber][4]));
    return ID;
  }
  
  public void toNextLine(){
    linecount++;
  }
  
  public int getCurrentYear(){
    return Integer.parseInt(trim(csv[linecount][2]));
  }
}
