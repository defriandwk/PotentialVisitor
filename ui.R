dashboardPage(
  
  dashboardHeader(
    title = "Potential visitor Prediction"
    
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        text = "Beranda",
        tabName = "home",
        icon = icon("home")
      ),
      
      menuItem(
        text = "Visualisasi Data",
        tabName = "return",
        icon = icon("map")
      ),
      menuItem(
        text = "Performa Machine Learning",
        tabName = "model",
        icon = icon("cog")
      ),
      menuItem(
        text = "Potential Detector",
        tabName = "detect",
        icon = icon("tasks")
      ),
      menuItem(
        text = "Kesimpulan",
        tabName = "summary",
        icon = icon("info")
      ),
      menuItem(
        text = "Tentang",
        tabName = "about",
        icon = icon("address-book")
      )
    )
  ),
    dashboardBody(
      shinyDashboardThemes(
        theme = "blue_gradient"
      ),
        tabItems(
            tabItem(
                tabName = "home",
                fluidRow(
                  div(align = "center",img(src = "lice.png",height = 400, width = 400)),
                  div(h1(strong("Potential Visitor Prediction"), align = "center")),
                  div(h3("Potential Visitor Prediction adalah sebuah dashboard machine learning yang akan mempelajari perilaku pengguna dan akan memprediksi
                        apakah pengguna akan melakukan transaksi pada kunjungan berikutnya",align = "center"))
                )
            ),
            
            tabItem(
              tabName = "return",
              fluidPage(
                fluidRow(
                  box(
                    title = "Returning Visitor Ratio",
                    width = 12,
                    valueBox(value = div(align = "center","98.8%" ),width = 9,
                             subtitle = div(align = "center","Non Return Visitor" ),
                             color = "navy"),
                    valueBox(value = div(align = "center","1.2%" ),width = 3,
                             subtitle = div(align = "center","Return Visitor" ),
                             color = "teal"),
                    
                    div(h3("Dari persentase diatas, hanya terdapat 1.2% pengunjung website yang melakukan transaksi di kunjungan selanjutnya. Sehingga bagian CRM kedepannya dapat
                         fokus ke visitor yang berpotensial untuk melakukan transaksi yang dapat berdampak pada penghematan sumber daya.",align = "center")),
                  ),
                  box(
                    title = "Return Visitor Device",
                    width = 6,
                    plotlyOutput("RDevice")
                  ),
                  box(
                    title = "Leave without interaction",
                    width = 6,
                    plotlyOutput("count10")
                  ),
                  box(
                    title = "Return Visitor Reference",
                    width = 6,
                    plotlyOutput("medi")
                  ),
                  box(
                    title = "Average Time Spend",
                    width = 6,
                    plotlyOutput("spend")
                  )
                )
              )
            ),
            
            tabItem(
              tabName = "model",
              fluidRow(
                linebreaks(2),
                div(h2(strong("Isolation Forest"),align = "center")),
                div(h4("Algoritma deteksi anomali pada data dengan membuat anomali score untuk masing-masing data. Isolation forest akan memisahkan data yang anomali 
                       berdasarkan seberapa jauh jatuhnya anomali skor dibanding data biasa.",align = "center")),
                div(h2(strong("Performa"),align = "center")),
                div(align = "center",img(src = "roc.png",height = 400, width = 800)),
                div(h4(strong("AUC = 0.81"), align = "center")),
                div(h4("Skor AUC (Area Under Curve) yang semakin mendekati 1 menunjukkan metode memiliki kinerja yang cukup bagus dalam mendeteksi anomali pada data yang 
                       digunakan setelah dilakukan penyesuian parameter model",align = "center")),
              )
            ),
            
            tabItem(
                tabName = "detect",
                fluidRow(
                  box(
                    width = 6,
                    selectInput(inputId = "medium",
                                label = "Medium:", 
                                choices = c("Organic" = "organic",
                                            "Cost per Click (CPC)"= "cpc",
                                            "Referral"="referral",
                                            "Cost per mille (CPM)"="cpm",
                                            "Affiliate"="affiliate")),
                    selectInput(inputId = "channel",
                                label = "Channel Grouping:", 
                                choices = unique(train$channelGrouping)),
                    selectInput(inputId = "bounces",
                                label = "Menutup website tanpa interaksi:", 
                                choices = c("Yes" = 1,
                                            "No" = 2)),
                    selectInput(inputId = "country",
                                label = "Negara :", 
                                choices = sort(unique(train$country))),
                    selectInput(inputId = "device",
                                label = "Perangkat yang digunakan:", 
                                choices = unique(train$deviceCategory)),
                    sliderInput(inputId = "progress", 
                                label = "Sampai tahap mana customer :",
                                min = 0,
                                max = 8,
                                value = 0),
                    "*Klik daftar produk = 1, Melihat detail produk = 2, 
                    Menambah produk ke keranjang = 3, Hapus produk dari keranjang = 4, Check out = 5, 
                    Menyelesaikan transaksi = 6, Pengembalian produk = 7, Pilih metode pembayaran = 8, Tidak diketahui = 0",
                    numericInput(inputId = "time", 
                                 label = "Time onSite dalam detik", 
                                 value = 0,
                                 min = 0, 
                                 max = 15000),
                    actionButton(inputId = "click",label = "Prediksi",class = "btn-primary", width = "505px")
                  )
                  ,
                  box(
                    title = "Prediksi per Pengguna",
                    width = 6,
                    height = 690,
                    div(h3("Pada kunjungan berikutnya, visitor memiliki kemungkinan melakukan transaksi sebesar", align = "center")),
                    linebreaks(4),
                    div(h1(strong(htmlOutput("prediksi")), align = "center", style = "font-size:1000%")),
                    linebreaks(1),
                    div(h1(strong(htmlOutput("kata")), align = "center", style = "font-size:200%"))
                  ),
                  box(
                    title = "Prediksi CSV",
                    width = 12,
                    fileInput("file1", "Pilih file CSV", accept = ".csv"),
                    downloadButton("downloadData", "Download Data Template"),
                    dataTableOutput("contents"),
                    collapsible = T
                  )
                )
            ),
            tabItem(
              tabName = "summary",
              fluidRow(
                
                box(
                  width = 12,
                  
                div(h1(strong("Kesimpulan"),align = "center")),
                div(h3("Metode Isolation Forest yang merupakan algoritma deteksi anomali pada data dapat memprediksi seberapa potensial pengunjung sebuah website dengan skor AUC = 0.81.",align = "center")),
                linebreaks(2),
                div(align = "center",img(src = "chart.png",height = 400, width = 700)),
                linebreaks(2),
                div(h3("Berdasarkan data test, dari 49.013 pengunjung website, ada 9.625 pengunjung potensial yang bisa dijadikan fokus marketing yang lebih tepat sasaran, 
                       yang berarti solusi machine learning ini dapat menghemat 80% sumber daya dibandingkan dengan melakukan approach ke semua pengunjung.",align = "center")),
                linebreaks(1)
              )
              )
            ),
            tabItem(
                tabName = "about",
                fluidRow(
                    box(
                      width = 12,
                      
                      
                        h1(strong("Defrian Dwi Kurniawan"), align = "center"),
                      linebreaks(1),
                      div(align = "center",img(src = "def.jpg",height = 250, width = 190)),
                      linebreaks(1),
                      div(h3("Perkenalkan saya Defrian Dwi Kurniawan, biasa dipanggil Defrian. Lulus dari Politeknik Caltex Riau di Program Studi Sistem Informasi
                             pada tahun 2020. Mulai menggeluti dunia data semenjak tahun 2019 dengan membangun sebuah dashboard Business Intelligence. Setelah lulus, 
                             mendalami bidang data dengan mengikuti Algoritma Data Science School. Klik dibawah untuk mengenal saya lebih lanjut",align = "center")),
                      linebreaks(1),
                      div(h4("e-Mail : defrian8@gmail.com",align = "center")),
                      h1(strong(actionButton(inputId='ab1', label="LinkedIn", 
                                             icon = icon("linkedin"), 
                                             onclick ="window.open('https://www.linkedin.com/in/defriandwi/', '_blank')"),
                                actionButton(inputId='ab2', label="Instagram", 
                                             icon = icon("instagram"), 
                                             onclick ="window.open('https://www.instagram.com/defriandwk/', '_blank')"),
                                actionButton(inputId='ab3', label="RPubs", 
                                             icon = icon("registered"), 
                                             onclick ="window.open('https://rpubs.com/defriandwk', '_blank')"),
                                actionButton(inputId='ab4', label="Github", 
                                             icon = icon("github"), 
                                             onclick ="window.open('https://github.com/defriandwk/, '_blank')")), align = "center"),
                      linebreaks(5),
                      
                      )
                    )
                )
            )
        )
    )
