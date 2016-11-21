# First setup of the model
remove(list=ls()) # Remove all variables from memory
on=1;off=0;

require(fields)  # image.plot originates here

setwd('/Simulations/OpenCL/clGray-Scott/clGray-Scott')

# Parameter settings
Movie     = off  # Whether a movie is made
Wait      = off  # If on, the program waits after every frame
# Figure window size, should match movie dimensions
WinWidth  = 960  # Width of the figure window
WinHeight = 720  # Height of the figure window
DPI       = 144  # Figure scale

# Linking to file that contains the data
FileName = "Output.dat"
cat(paste("Data file date :",file.info(FileName )$mtime ),"\n")
FID = file(FileName, "rb")

# Reading the settings from the file
NX = readBin(FID, integer(), n = 1, endian = "little");
NY = readBin(FID, integer(), n = 1, endian = "little");
Length=readBin(FID,  numeric(), size=4, n = 1, endian = "little")
NumFrames = readBin(FID, integer(), n = 1, endian = "little");
EndTime=readBin(FID,  integer(), n = 1, endian = "little")

# Color palette for the images, obtained from a real-wold picture
#Bush.palette= colorRampPalette(c("#cd9557", "#f8e29f", "#82A045", "#628239", "#506736","#385233"))


# --- Opening a window --------------------------------------------------------
if (Movie==off) 
  quartz(width=WinWidth/DPI, height=WinHeight/DPI, dpi=DPI)

# --- The loop the plots each frame
for (jj in 0:(NumFrames-1)){  # Here the time loop starts 
  
   if (Movie==on) # plotting into a jpeg image
     tiff(filename = sprintf("Images/Rplot%03d.tiff",jj),
          width = WinWidth, height = WinHeight, 
          units = "px", pointsize = 24,
          compression="none",
          bg = "white", res = NA,
          type = "quartz")  
   
   # Loading the data for a single frame
   Data_W = matrix(nrow=NY, ncol=NX, readBin(FID, numeric(), size=4, n = NX*NY, endian = "little"));
   Data_N = matrix(nrow=NY, ncol=NX, readBin(FID, numeric(), size=4, n = NX*NY, endian = "little"));
   
   par(mar=c(2, 3, 2, 5) + 0.1)  # margin settings
   
   image.plot(pmin(Data_N[,2:(NX-1)],0.4), zlim=c(0,0.4), xaxt="n", yaxt="n",
              asp=1, bty="n", useRaster=TRUE, 
              legend.shrink = 0.99, legend.width = 2,
              legend.args=list(text=expression(Concentration),
                               cex=0.8, line=0.5))  
   title("Substance V")   

   mtext(text=sprintf("Time : %1.0f of %1.0f timesteps", (jj+1)/NumFrames*EndTime, EndTime), 
         side=1, adj=0.5, line=0.5, cex=1)   
   
   # Adding the scale bar and text
   #axis(side=1, at=c(0.8,1), line=0.5, labels = c(0,trunc(Length/5+0.5)), 
   #     cex.axis=0.8, tck = -0.015, mgp=c(3, .25, 0))
   
   #mtext(text="Scale (m)", side=1, adj=1.2, line=0.5, cex=0.8)
   
  if (Movie==on) dev.off() else { 
    dev.flush()  # this prevents flickering    
    dev.hold()   # screen is frozen again
  }
  if (Wait==on){
    cat ("Press [enter] to continue, [q] to quit")
    line <- readline()
    if (line=='q'){ stop() }
  } 
}

close(FID)

# --- Here, a movie is made by parameterezing ffmpeg --------------------------
if (Movie==on) { 
  
  InFiles=paste(getwd(),"/Images/Rplot%03d.tiff", sep="")
  OutFile="Gray-Scott.mp4"
  
  print(paste(" building :", OutFile))
  
  CmdLine=sprintf("ffmpeg -y -r 30 -i %s -c:v libx264 -pix_fmt yuv420p -b:v 2000k %s", InFiles, OutFile)
  cmd = system(CmdLine)
  
  # if (cmd==0) try(system(paste("open ", paste(getwd(),"Mussels_PDE.mp4"))))
} 

system('say All ready')

