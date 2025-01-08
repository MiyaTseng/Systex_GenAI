CREATE TABLE `Users` (
  `ID` integer PRIMARY KEY,
  `Username` varchar(255) COMMENT '用戶的登入帳號',
  `Password` varchar(255) COMMENT '加密後的密碼',
  `Full_Name` varchar(255) COMMENT '用戶的全名',
  `Contact_Info` varchar(255) COMMENT '用戶的聯絡方式，例如：電話或郵件',
  `Created_Date` timestamp COMMENT '帳號建立的日期',
  `Updated_Date` timestamp COMMENT '帳號最後更新的日期'
);

CREATE TABLE `User_Roles` (
  `ID` integer PRIMARY KEY,
  `User_ID` integer COMMENT '對應到 Users 的 ID',
  `Role` varchar(255) COMMENT '用戶的角色，例如 student, trainer, admin'
);

CREATE TABLE `Students` (
  `ID` integer PRIMARY KEY,
  `User_ID` integer COMMENT '關聯到 Users 的 ID，必須是 student 角色',
  `Trainer_ID` integer COMMENT '學生所屬的教練 ID',
  `Gender` varchar(255) COMMENT '學生的性別（如：男、女、其他）',
  `Age` integer COMMENT '學生的年齡',
  `Height` integer COMMENT '學生的身高（單位：公分）',
  `Weight` integer COMMENT '學生的體重（單位：公斤）',
  `Fitness_Goals` json COMMENT '學生的健身目標，例如：{"lose_weight": true, "gain_muscle": true}',
  `Membership_Status` varchar(255) COMMENT '會員狀態（如：活躍、過期、待續約）',
  `Points` integer COMMENT '學生的累積積分',
  `Gym_ID` integer COMMENT '所屬健身房的 ID'
);

CREATE TABLE `Trainers` (
  `ID` integer PRIMARY KEY,
  `User_ID` integer COMMENT '關聯到 Users 的 ID，必須是 trainer 角色',
  `Specialization` varchar(255) COMMENT '教練的專業領域，例如：增肌訓練、瑜伽',
  `Certification` varchar(255) COMMENT '教練的專業證書或資格',
  `Experience` integer COMMENT '教練的從業年數',
  `Available_Times` json COMMENT '教練的可預約時間，例如：{"Monday": "10:00-18:00"}',
  `Rating` decimal COMMENT '教練的平均評分（1.0 到 5.0）',
  `Photo` varchar(255) COMMENT '教練個人照片的 URL 或路徑',
  `Description` text COMMENT '教練的個人簡介或背景介紹',
  `Gym_ID` integer COMMENT '所屬健身房的 ID',
  `Is_Active` boolean COMMENT '教練是否目前提供服務（true/false）'
);

CREATE TABLE `Training_Menus` (
  `ID` integer PRIMARY KEY,
  `Name` varchar(255) COMMENT '訓練菜單名稱，例如：增肌初學者計劃',
  `Exercises` json COMMENT '包含的運動項目，例如：["跑步機", "啞鈴深蹲"]',
  `Target_Muscles` json COMMENT '目標肌肉群，例如：["胸肌", "腿部"]',
  `Duration` integer COMMENT '菜單建議的訓練時間，單位分鐘',
  `Calories_Burned` integer COMMENT '預計燃燒的卡路里',
  `Difficulty` varchar(255) COMMENT '難度級別，例如：初學者、中級、高級',
  `Created_Date` timestamp COMMENT '菜單建立的日期',
  `Updated_Date` timestamp COMMENT '菜單最後更新的日期'
);

CREATE TABLE `Points_Redemption` (
  `ID` integer PRIMARY KEY,
  `Student_ID` integer COMMENT '積分兌換的學生 ID',
  `Redeemable_Item` varchar(255) COMMENT '兌換的物品名稱，例如：免費教練課',
  `Points_Spent` integer COMMENT '兌換花費的積分',
  `Redeemed_Date` timestamp COMMENT '兌換日期'
);

CREATE TABLE `Gym_Locations` (
  `ID` integer PRIMARY KEY,
  `Name` varchar(255) COMMENT '健身房名稱',
  `Address` text COMMENT '健身房的詳細地址',
  `Opening_Hours` varchar(255) COMMENT '健身房的營業時間',
  `Contact_Number` varchar(255) COMMENT '健身房的聯絡電話'
);

CREATE TABLE `Equipment` (
  `ID` integer PRIMARY KEY,
  `Name` varchar(255) COMMENT '器材名稱，例如：跑步機、啞鈴',
  `Description` text COMMENT '器材描述，例如：使用說明或功能'
);

CREATE TABLE `Gym_Equipment` (
  `ID` integer PRIMARY KEY,
  `Gym_ID` integer COMMENT '健身房 ID',
  `Equipment_ID` integer COMMENT '器材 ID',
  `Quantity` integer COMMENT '健身房內該器材的數量',
  `Status` varchar(255) COMMENT '器材狀態，例如 available, in_maintenance'
);

CREATE TABLE `Equipment_Videos` (
  `ID` integer PRIMARY KEY,
  `Equipment_ID` integer COMMENT '器材 ID',
  `Video_URL` text COMMENT '教學影片的 URL',
  `Description` text COMMENT '影片簡要描述'
);

CREATE TABLE `Training_Logs` (
  `ID` integer PRIMARY KEY,
  `Student_ID` integer COMMENT '完成訓練的學生 ID',
  `Training_Menu_ID` integer COMMENT '對應的訓練菜單 ID',
  `Completion_Date` timestamp COMMENT '完成訓練的日期'
);

ALTER TABLE `Students` ADD FOREIGN KEY (`ID`) REFERENCES `Training_Logs` (`Student_ID`);

ALTER TABLE `Training_Menus` ADD FOREIGN KEY (`ID`) REFERENCES `Training_Logs` (`Training_Menu_ID`);

ALTER TABLE `Users` ADD FOREIGN KEY (`ID`) REFERENCES `User_Roles` (`User_ID`);

ALTER TABLE `Users` ADD FOREIGN KEY (`ID`) REFERENCES `Students` (`User_ID`);

ALTER TABLE `Users` ADD FOREIGN KEY (`ID`) REFERENCES `Trainers` (`User_ID`);

ALTER TABLE `Gym_Locations` ADD FOREIGN KEY (`ID`) REFERENCES `Students` (`Gym_ID`);

ALTER TABLE `Gym_Locations` ADD FOREIGN KEY (`ID`) REFERENCES `Trainers` (`Gym_ID`);

ALTER TABLE `Gym_Locations` ADD FOREIGN KEY (`ID`) REFERENCES `Gym_Equipment` (`Gym_ID`);

ALTER TABLE `Equipment` ADD FOREIGN KEY (`ID`) REFERENCES `Gym_Equipment` (`Equipment_ID`);

ALTER TABLE `Equipment` ADD FOREIGN KEY (`ID`) REFERENCES `Equipment_Videos` (`Equipment_ID`);

ALTER TABLE `Students` ADD FOREIGN KEY (`ID`) REFERENCES `Points_Redemption` (`Student_ID`);
