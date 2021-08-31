function(input, output){
  observeEvent(input$click,{
    df <- data.frame(
      latest_ecommerce_progress = input$progress,
      bounces = input$bounces,
      time_on_site = input$time,
      medium = input$medium,
      channelGrouping = input$channel,
      deviceCategory = input$device,
      country = input$country
    )
    
    output$prediksi <- renderText({
      pred <- predict(model, df) %>% 
        round(2) * 100
      if(pred<=50){
        paste("<font color=\"#FF0000\">" ,pred, "%", "</font>")
      }
      else{
        paste("<font color=\"#0073b7\">" ,pred, "%", "</font>")
      }
    })
    
    output$kata <- renderText({
      pred <- predict(model, df) %>% 
        round(2) * 100
      if(pred<=50){
        paste("Terprediksi pengguna","<font color=\"#FF0000\">" ,"kurang berpotensi", "</font>", "untuk melakukan transaksi di kunjungan berikutnya")
      }
      else{
        paste("Terprediksi pengguna","<font color=\"#0073b7\">" ,"berpotensi", "</font>", "untuk melakukan transaksi di kunjungan berikutnya")
      }
      
    })
  })
    
  output$RDevice <- renderPlotly({
    
      ret <- train %>% 
      filter(will_buy_on_return_visit==1) %>% 
        count(deviceCategory) %>% 
        mutate(label = glue("Jumlah pengguna: {n}"))
    
      s <- ggplot(ret, aes(deviceCategory, n, text=label))+
        geom_col(fill = c("#0d3f4d","#39cccc","#000000"))+
        labs(
          x = "",
          y = "Jumlah Pengguna"
        )+ theme_economist_white(gray_bg = FALSE)
      

    ggplotly(s, tooltip = "text")
  })
  
  output$spend <- renderPlotly({
    
    spe <- train %>% 
      group_by(will_buy_on_return_visit) %>% 
      summarize(n = mean(time_on_site))%>% 
      mutate(will_buy_on_return_visit = str_replace_all(will_buy_on_return_visit, pattern = "1","Return Visitor"),
             will_buy_on_return_visit = str_replace_all(will_buy_on_return_visit, pattern = "0","Non Return Visitor"),
        n = round(n, 2),
             label = glue("Rata-rata Time On Site : {n} detik"))
    
    spendplot <- ggplot(spe, aes(will_buy_on_return_visit, n, text=label))+
      geom_col(fill = c("#0d3f4d","#39cccc"))+
      labs(
        x = "Tipe Pengunjung",
        y = "Time On Site (detik)"
      )+ theme_economist_white(gray_bg = FALSE)
    
    ggplotly(spendplot, tooltip = "text")
  })
  
  output$count10 <- renderPlotly({
    
    cou <- train %>% 
      
      count(bounces) %>% 
      mutate(bounces = str_replace_all(bounces, pattern = "1","Yes"),
             bounces = str_replace_all(bounces, pattern = "0","No"),
             label = glue("Jumlah pengguna: {n}"))
    
    c <- ggplot(cou, aes(bounces,n,text=label))+
      geom_col(fill = c("#0d3f4d","#39cccc"))+
      labs(
        x = "",
        y = "Jumlah Pengguna"
      )+ theme_economist_white(gray_bg = FALSE)
    
    
    ggplotly(c , tooltip = "text")
  })

  output$medi <- renderPlotly({
    
    med <- train %>% 
      filter(will_buy_on_return_visit==1) %>% 
      count(medium) %>% 
      mutate(label = glue("Medium : {medium} \n
                          Jumlah Pengguna : {n}"))
    
    plot_ly(med, labels = ~medium, values = ~n) %>%
      add_pie(hole = 0.6) %>%
      layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = TRUE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = TRUE))
    
  })
  
  output$contents <- renderDataTable({
    file <- input$file1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Silahkan upload file csv"))
    
    jalan <- read.csv(file$datapath)
    jalan <- jalan %>% 
      replace_with_na(replace = list(medium = c("(none)","(not set)"))) %>% 
      na.omit() %>% 
      select(-c(source, pageviews)) %>% 
      droplevels()
    
    predi <- predict(model, jalan) %>% 
      round(2) * 100
    jalan$Prediksi <- predi
    jalan <- jalan %>% 
      mutate(Hasil = glue("{Prediksi} %")) %>% 
      select(-Prediksi)
    jalan
  })
  
  output$downloadData <- downloadHandler(
    filename = "sample.csv",
    content = function(file) {
      write.csv(sample, file, row.names = FALSE)
    }
  )
  }
