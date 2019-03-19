#To be inserted at 8006b798
.include "../../Common/Common.s"
.include "../../Recording/Recording.s"

.set REG_PlayerData,31
.set REG_Buffer,4
.set FramesBetweenPresses,20

#Check if pressing DPad down
  lwz r3,0x668(REG_PlayerData)
  rlwinm. r3,r3,0,29,29
  beq Exit
#Check how long since they last pressed DPad down
  lbz r3, DPadDownTimer(REG_PlayerData)
  cmpwi r3,FramesBetweenPresses
  bgt Exit

#####################
## Send Star Event ##
#####################
#Get secondary buffer
  lwz REG_Buffer,secondaryDataBuffer(r13)
#Send event ID
  li  r3,STAR_REPLAY
  stb r3,0x0(REG_Buffer)
#Send player ID
  lbz r3,0xC(REG_PlayerData)
  stb r3,0x1(REG_Buffer)
#Send frame number
  lwz r3,frameIndex(r13)
  stw r3,0x2(REG_Buffer)
#------------- Transfer Buffer ------------
  mr  r3,REG_Buffer
  li  r4,STAR_REPLAY_PAYLOAD_LENGTH+1
  li  r5,CONST_ExiWrite
  branchl r12,FN_EXITransferBuffer
#Play SFX
  li  r3,1
  branchl r12,0x80024030
  
Exit:
  lbz	r0, 0x2219 (REG_PlayerData)
