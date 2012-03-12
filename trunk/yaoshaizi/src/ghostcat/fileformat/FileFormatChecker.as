package ghostcat.fileformat
{
	import flash.utils.ByteArray;

	/**
	 * 根据文件头判断文件格式
	 * @author flashyiyi
	 * 
	 */
	public class FileFormatChecker
	{
		static private const FORMAT_DATA:Array = ["FFD8FFFE","FFD8FFE","474946383961","474946383761","424D","4D5A","504B0304","3A42617365",
			"D0CF11E0A1B11AE1","0100000058000000","03000000C466C456","3F5F0300","1F8B08","28546869732066696C65","4C000000011402",
			"25504446","5245474544495434","7B5C727466","0A050108","25215053","2112","1A02","1A03","1A04","1A08","1A09","60EA","41564920","425A68",
			"49536328","4C01","303730373037","4352555348","3ADE68B1","1F8B","91334846","3C68746D6C3E","3C48544D4C3E","3C21444F4354","0100",
			"5F27A889","2D6C68352D","20006040600","00001A0007800100","00001A0000100400","20006800200","00001A0002100400","5B7665725D",
			"300000041505052","1A0000030000","4D47582069747064","4D534346","4D546864","000001B3","0902060000001000B9045C00",
			"0904060000001000F6055C00","7FFE340A","1234567890FF","31BE000000AB0000","1A00000300001100","7E424B00","504B0304","89504E470D0A",
			"6D646174","6D646174","52617221","2E7261FD","EDABEEDB","2E736E64","53495421","53747566664974","1F9D","49492A","4D4D2A","554641",
			"57415645666D74","D7CDC69A","4C000000","504B3030504B0304","FF575047","FF575043","3C3F786D6C",
			"FFFE3C0052004F004F0054005300540055004200","3C21454E54495459","5A4F4F20","435753","465753","49443330000",
			"3026B2758E66CF11A6D90AA062CE6C"];
		
		static private const FORMAT_NAME:Array = ["JPG","JPG","GIF","GIF","BMP",["EXE","COM","DLL"],"ZIP","CNT",["DOC","XLS","PPT","APR"],"EMF","EVT",
			["GID","HLP","LHP"],"GZ","HQX","LNK","PDF","REG","RTF","PCX","EPS","AIN","ARC","ARC","ARC","ARC","ARC","ARJ","AVI","BZ","CAB","OBJ",
			"TAR","CRU","DCX","GZ","HAP","HTM","HTM","HTM","ICO","JAR","LHA","WK1","FM3","WK3","FMT","WK4","AMI","ADX","NSF","DS4","CAB","MID","MPG",
			"XLS","XLS","DOC","DOC","DOC","NSF","PSP","ZIP","PNG","MOV","QT","RAR","RA","RPM","AU","SIT","SIT","Z","TIF","TIF","UFA",
			"WAV","WMF","LNK","ZIP","WPG","WP","XML","XML","DTD","ZOO","SWF","SWF","MP3","WMA"];
		
		
		static public function getTypeFormat(bytes:ByteArray):*
		{
			var l:int = bytes.length < 20 ? bytes.length : 20;
			var key:String = "";
			for (var i:int = 0;i < l;i++)
			{
				key += bytes.readUnsignedByte().toString(16).toUpperCase();
				var index:int = FORMAT_DATA.indexOf(key);
				if (index != -1)
					return FORMAT_NAME[index];
			}
			return null;
		}
	}
}


//http://www.fix.com.cn/datarecover/data-recovery53.htm
