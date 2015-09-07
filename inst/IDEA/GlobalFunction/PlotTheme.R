library(ggplot2)

#define theme
plotDefaultTheme=theme(
  panel.background = element_rect(fill = "white", color = "black"),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  axis.text.x = element_text(angle = 90, color = "black",size = 15),
  axis.text.y = element_text(angle = 00, color = "black",size = 15),
  axis.title = element_text(face = "bold", color = "black", size = 20),
  legend.title = element_text(face = "bold", color = "black", size = 20),
  legend.text = element_text(color = "black", size = 20)
)
#axis.x without rotate
plotDefaultTheme2=theme(
  panel.background = element_rect(fill = "white", color = "black"),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  axis.text.x = element_text(angle = 0, color = "black",size = 15),
  axis.text.y = element_text(angle = 0, color = "black",size = 20),
  axis.title = element_text(face = "bold", color = "black", size = 20),
  legend.title = element_text(face = "bold", color = "black", size = 20),
  legend.text = element_text(color = "black", size = 20)
)