class converter{

  List<String> dist=["Dhaka", "Faridpur", "Gazipur",
  "Gopalganj", "Jamalpur", "Kishoreganj", "Madaripur",
  "Manikganj", "Munshiganj", "Mymensingh", "Narayanganj",
  "Narsingdi", "Netrokona", "Rajbari", "Shariatpur", "Sherpur",
  "Tangail", "Bogra", "Joypurhat", "Naogaon", "Natore", "Nawabganj",
  "Pabna", "Rajshahi", "Sirajgonj", "Dinajpur", "Gaibandha", "Kurigram",
  "Lalmonirhat", "Nilphamari", "Panchagarh", "Rangpur", "Thakurgaon", "Barguna",
  "Barisal", "Bhola", "Jhalokati", "Patuakhali", "Pirojpur", "Bandarban", "Brahmanbaria",
  "Chandpur", "Chittagong", "Comilla", "Cox's Bazar", "Feni", "Khagrachari", "Lakshmipur",
  "Noakhali", "Rangamati", "Habiganj", "Maulvibazar", "Sunamganj", "Sylhet", "Bagerhat", "Chuadanga",
  "Jessore", "Jhenaidah", "Khulna", "Kushtia", "Magura", "Meherpur", "Narail","Satkhira"];

  List<String> bangla_dist=["ঢাকা", "ফরিদপুর", "গাজীপুর", "গোপালগঞ্জ", "জামালপুর", "কিশোরগঞ্জ", "মাদারীপুর", "মানিকগঞ্জ",
  "মুন্সীগঞ্জ", "ময়মনসিংহ", "নারায়ণগঞ্জ", "নরসিংদী", "নেত্রকোনা", "রাজবাড়ী", "শরীয়তপুর", "শেরপুর", "টাঙ্গাইল",
  "বগুড়া", "জয়পুরহাট", "নওগাঁ", "নাটোর", "নবাবগঞ্জ", "পাবনা", "রাজশাহী", "সিরাজগঞ্জ", "দিনাজপুর", "গাইবান্ধা",
  "কুড়িগ্রাম", "লালমনিরহাট", "নীলফামারী", "পঞ্চগড়", "রংপুর", "ঠাকুরগাঁও", "বরগুনা", "বরিশাল", "ভোলা", "ঝালকাঠি",
  "পটুয়াখালী", "পিরোজপুর", "বান্দরবান", "ব্রাহ্মণবাড়িয়া", "চাঁদপুর", "চট্টগ্রাম", "কুমিল্লা", "কক্সবাজার", "ফেনী", "খাগড়াছড়ি",
  "লক্ষ্মীপুর", "নোয়াখালী", "রাঙামাটি", "হবিগঞ্জ", "মৌলভীবাজার", "সুনামগঞ্জ", "সিলেট", "বাগেরহাট", "চুয়াডাঙ্গা", "যশোর",
  "ঝিনাইদহ", "খুলনা", "কুষ্টিয়া", "মাগুরা", "মেহেরপুর", "নড়াইল", "সাতক্ষীরা"];


  List<String> div=["Dhaka","Chittagong","Khulna","Rangpur","Rajshahi","Mymensingh","Sylhet","Barisal"];
  List<String> bangla_div=["ঢাকা","চট্টগ্রাম","খুলনা","রংপুর","রাজশাহী","ময়মনসিংহ","সিলেট","বরিশাল"];

  String dist_converter(String en)
  {
    for(int i=0;i<dist.length;i++)
      {
        if(en==dist[i])
          {
            return bangla_dist[i];
          }
      }
    return "";
  }
  String div_converter(String en)
  {
    for(int i=0;i<div.length;i++)
    {
      if(en==div[i])
      {
        return bangla_div[i];
      }
    }
    return "";
  }

  int? code_generator(String bn)
  {
    for(int i=0;i<bangla_dist.length;i++)
    {
      if(bn==bangla_dist[i])
      {
        return i;
      }
    }
    return 0;
  }


}