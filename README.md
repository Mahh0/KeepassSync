<!-- PROJECT LOGO -->
<br />
  <h3 align="center">Web Scraping of Presidential Agenda</h3>

  <p align="center">
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Template used »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Mahh0/Web-Scraping-Of-Presidential-Agenda/pulls">Pull Request</a>
    ·
    <a href="https://github.com/Mahh0/Web-Scraping-Of-Presidential-Agenda/issues">Report Bug</a>
  </p>
</div>


<!-- ABOUT THE PROJECT -->
## About The Project

This project is a project for the semesters 3 & 4 for <a href="https://iut-blois.univ-tours.fr/version-francaise/formations/dut-reseaux-et-telecommunications">IUT R&T Of Blois</a>

The goal of this project is to scrape datas from <a href="https://www.elysee.fr/agenda">French Presidential Agenda Website</a>. This projects was built with VSCode, Java, <a href="https://jsoup.org/">Jsoup Library</a>, a <a href="https://www.mysql.com/fr/">MySql Database</a>.

### Built With

* [Jsoup](https://jsoup.org/)
* [Java](https://www.java.com/fr/)
* [VSCode](https://code.visualstudio.com/)
* [MySQL and JDBC](https://dev.mysql.com/downloads/)
* [Maven](https://maven.apache.org/)


### Prerequisites
* [VSCode](https://code.visualstudio.com/)
* [MySQL server, with installed database](https://dev.mysql.com/downloads/)

### Installation (Windows and Linux)

1. Unzip the files or clone in your workspace
* 
  ```sh
  git clone https://github.com/Mahh0/Web-Scraping-Of-Presidential-Agenda
  ```

2. Install the MySQL Database. A MySQL dump is provided in ```Web-Scraping-Of-Presidential-Agenda\webScraping\src\main\resources\Database```
```sh
cd ".\Web-Scraping-Of-Presidential-Agenda\webScraping\src\main\resources\Database"
mysql -u root -proot
  create database webscraping;
  exit
  
mysql -u root -p webscraping < MySQL_DUMP.sql
```

3. Be sure that you have java configured on VSCode and maven can be necessary.

4. Enjoy


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/Mahh0/Web-Scraping-Of-Presidential-Agenda/issues) for a list of proposed features (and known issues).
All reports of this project can be found on my [Google Drive](https://drive.google.com/drive/folders/1o6rennKfMEGkGxXvfB0qvTHNwIg8ggoW?usp=sharing) 🇫🇷



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- CONTACT -->
## Contact

[@MAH0_](https://twitter.com/MAH0_) - maho.spotify@gmail.com

Project Link: [https://github.com/Mahh0/Web-Scraping-Of-Presidential-Agenda](https://github.com/Mahh0/Web-Scraping-Of-Presidential-Agenda)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [GitHub Pages](https://pages.github.com)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
