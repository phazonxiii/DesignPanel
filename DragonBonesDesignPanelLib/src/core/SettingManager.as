package core
{
	import flash.errors.IllegalOperationError;
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	
	import core.model.vo.ImportVO;
	import core.model.vo.ExportVO;
	import core.utils.GlobalConstValues;
	
	[Bindable]
	public class SettingManager
	{
		private static const SHARE_LOCAL:String = "DragonBones/DesignPanel";
		private static const LANGUAGE_ID:String = "languageID";
		
		private static const IMPORT_TYPE:String = "importType";
		private static const IMPORT_FADE_IN_TIME:String = "importFadeInTime";
		private static const SIZE_CONSTRAINTS:String = "sizeConstraints";
		//private static const MERGE_LAYERS_IN_FOLDER:String = "mergeLayersInfolder";
		
		private static const EXPORT_DATA_FORMAT:String = "exportDataFormat";
		private static const EXPORT_TEXTURE_FORMAT:String = "exportTextureFormat";
		
		private static const EXPORT_SCALE:String = "exportScale";
		private static const EXPORT_BACKGROUND_COLOR:String = "exportBackgoundColor";
		
		private static const BONE_HIGHLIGHT_ENABLED:String = "boneHighlightEnabled";
		private static const BONE_HIGHLIGHT_COLOR:String = "boneHighlightColor";
		private static const BACKGROUND_COLOR:String = "backgoundColor";
		
		private static const TEXTURE_ATLAS_PATH:String = "exportTextureAtlasPath";
		private static const DRAGON_BONES_FILE_NAME:String = "dragonBonesFileName";
		private static const TEXTURE_ATLAS_FILE_NAME:String = "textureAtlasFileName";
		private static const TEXTURE_ATLAS_CONFIG_FILE_NAME:String = "textureAtlasConfigFileName";
		private static const SUB_TEXTURE_FOLDER_NAME:String = "subTextureFolderName";
		
		private static const USER_NAME:String = "userName";
		private static const USERE_MAIL:String = "userEmail";
		
		private static var _instance:SettingManager;
		public static function getInstance():SettingManager
		{
			if (_instance)
			{
				return _instance;
			}
			return new SettingManager();
		}
		
		//
		public var languageAC:ArrayCollection = new ArrayCollection([
			{label:"English", value:"en_US"}, 
			{label:"中文", value:"zh_CN"},
			{label:"Français", value:"fr_FR"},
			{label:"日本語", value:"ja_JP"}
		]);
		
		//
		public var importTypeAC:ArrayCollection = new ArrayCollection([
			{value:GlobalConstValues.IMPORT_TYPE_FLA_ALL_LIBRARY_ITEMS, label:GlobalConstValues.IMPORT_TYPE_FLA_ALL_LIBRARY_ITEMS}, 
			{value:GlobalConstValues.IMPORT_TYPE_FLA_SELECTED_LIBRARY_ITEMS, label:GlobalConstValues.IMPORT_TYPE_FLA_SELECTED_LIBRARY_ITEMS}, 
			{value:GlobalConstValues.IMPORT_TYPE_EXPORTED, label:GlobalConstValues.IMPORT_TYPE_EXPORTED}
		]);
		
		//
		public var sizeConstraintsAC:ArrayCollection = new ArrayCollection([
			{value:0, label:"POT(Power of 2)"}, 
			{value:1, label:"Any Size"}, 
		]);
		
		//
		public var exportDataFormatAC:ArrayCollection = new ArrayCollection([
			{value:GlobalConstValues.CONFIG_TYPE_MERGED, label:GlobalConstValues.CONFIG_TYPE_MERGED}, 
			{value:GlobalConstValues.CONFIG_TYPE_AMF3, label:GlobalConstValues.CONFIG_TYPE_AMF3}, 
			{value:GlobalConstValues.CONFIG_TYPE_XML, label:GlobalConstValues.CONFIG_TYPE_XML}, 
			{value:GlobalConstValues.CONFIG_TYPE_JSON, label:GlobalConstValues.CONFIG_TYPE_JSON}
		]);
		
		//
		public var exportTextureFormatAC:ArrayCollection = new ArrayCollection([
			{value:GlobalConstValues.TEXTURE_ATLAS_TYPE_PNG, label:GlobalConstValues.TEXTURE_ATLAS_TYPE_PNG}, 
			{value:GlobalConstValues.TEXTURE_ATLAS_TYPE_PNGS, label:GlobalConstValues.TEXTURE_ATLAS_TYPE_PNGS}
		]);
		
		//
		public var exportTextureMergedFormatAC:ArrayCollection = new ArrayCollection([
			{value:GlobalConstValues.TEXTURE_ATLAS_TYPE_SWF, label:GlobalConstValues.TEXTURE_ATLAS_TYPE_SWF}, 
			{value:GlobalConstValues.TEXTURE_ATLAS_TYPE_PNG, label:GlobalConstValues.TEXTURE_ATLAS_TYPE_PNG}
		]);
		
		//
		public var textureAtlasWidthAC:ArrayCollection = new ArrayCollection(["Auto Size", 128, 256, 512, 1024, 2048, 4096]);
		
		public var textureAtlasWidthIndex:int = 0;
		public var textureAtlasPadding:int = 2;
		
		private var _shareObject:SharedObject = null;
		
		public function get textureAtlasWidth():int
		{
			if(textureAtlasWidthIndex == 0)
			{
				return 0;
			}
			return int(textureAtlasWidthAC.getItemAt(textureAtlasWidthIndex));
		}

		public function get languageIndex():int
		{
			return hasData(LANGUAGE_ID)?getData(LANGUAGE_ID):-1;
		}
		public function set languageIndex(value:int):void
		{
			if(languageIndex == value)
			{
				return;
			}
			setData(LANGUAGE_ID, value);
			updateLanguage();
		}
		
		public function get importTypeIndex():int
		{
			return hasData(IMPORT_TYPE)?getData(IMPORT_TYPE):0;
		}
		public function set importTypeIndex(value:int):void
		{
			value = value < 0 ? 0 : value;
			setData(IMPORT_TYPE, value);
		}
		
		public function get importFadeInTime():Number
		{
			return hasData(IMPORT_FADE_IN_TIME)?getData(IMPORT_FADE_IN_TIME):0.3;
		}
		public function set importFadeInTime(value:Number):void
		{
			setData(IMPORT_FADE_IN_TIME, value);
		}
		
		public function get sizeConstraintsIndex():int
		{
			return hasData(SIZE_CONSTRAINTS)?getData(SIZE_CONSTRAINTS):0;
		}
		public function set sizeConstraintsIndex(value:int):void
		{
			setData(SIZE_CONSTRAINTS, value);
		}
		
		/* 临时注释掉mergeLayersInFolder功能,代码先不要删
		public function get mergeLayersInFolder():Boolean
		{
			return hasData(MERGE_LAYERS_IN_FOLDER)?getData(MERGE_LAYERS_IN_FOLDER):false;
		}
		public function set mergeLayersInFolder(value:Boolean):void
		{
			setData(MERGE_LAYERS_IN_FOLDER, value);
		}
		*/
		
		public function get exportDataFormatIndex():int
		{
			return hasData(EXPORT_DATA_FORMAT)?getData(EXPORT_DATA_FORMAT):0;
		}
		public function set exportDataFormatIndex(value:int):void
		{
			if(exportDataFormatIndex == value)
			{
				return;
			}
			setData(EXPORT_DATA_FORMAT, value);
		}
		
		public function get exportTextureFormatIndex():int
		{
			return hasData(EXPORT_TEXTURE_FORMAT)?getData(EXPORT_TEXTURE_FORMAT):0;
		}
		public function set exportTextureFormatIndex(value:int):void
		{
			if(exportTextureFormatIndex == value)
			{
				return;
			}
			setData(EXPORT_TEXTURE_FORMAT, value);
		}
		
		public function get exportScale():Number
		{
			return hasData(EXPORT_SCALE)?getData(EXPORT_SCALE):1;
		}
		public function set exportScale(value:Number):void
		{
			if(value < 0 || value != value)
			{
				value = 1;
			}
			setData(EXPORT_SCALE, value);
		}
		
		public function get boneHighlightEnabled():Boolean
		{
			return hasData(BONE_HIGHLIGHT_ENABLED)?getData(BONE_HIGHLIGHT_ENABLED):true;
		}
		public function set boneHighlightEnabled(value:Boolean):void
		{
			setData(BONE_HIGHLIGHT_ENABLED, value);
		}
		public function get boneHighlightColor():uint
		{
			return hasData(BONE_HIGHLIGHT_COLOR)?getData(BONE_HIGHLIGHT_COLOR):0xFF0000;
		}
		public function set boneHighlightColor(value:uint):void
		{
			setData(BONE_HIGHLIGHT_COLOR, value);
		}
		
		public function get backgroundColor():uint
		{
			return hasData(BACKGROUND_COLOR)?getData(BACKGROUND_COLOR):0xFFFFFFFF;
		}
		public function set backgroundColor(value:uint):void
		{
			setData(BACKGROUND_COLOR, value);
		}
		
		public function get exportBackgroundColor():uint
		{
			return hasData(EXPORT_BACKGROUND_COLOR)?getData(EXPORT_BACKGROUND_COLOR):0xFFFFFFFF;
		}
		public function set exportBackgroundColor(value:uint):void
		{
			setData(EXPORT_BACKGROUND_COLOR, value);
		}
		
		public function get textureAtlasPath():String
		{
			return hasData(TEXTURE_ATLAS_PATH)?getData(TEXTURE_ATLAS_PATH):"";
		}
		public function set textureAtlasPath(value:String):void
		{
			setData(TEXTURE_ATLAS_PATH, value);
		}
		
		public function get dragonBonesFileName():String
		{
			return hasData(DRAGON_BONES_FILE_NAME)?getData(DRAGON_BONES_FILE_NAME):GlobalConstValues.DRAGON_BONES_DATA_NAME;
		}
		public function set dragonBonesFileName(value:String):void
		{
			setData(DRAGON_BONES_FILE_NAME, value);
		}
		
		public function get textureAtlasFileName():String
		{
			return hasData(TEXTURE_ATLAS_FILE_NAME)?getData(TEXTURE_ATLAS_FILE_NAME):GlobalConstValues.TEXTURE_ATLAS_DATA_NAME;
		}
		public function set textureAtlasFileName(value:String):void
		{
			setData(TEXTURE_ATLAS_FILE_NAME, value);
		}
		
		public function get textureAtlasConfigFileName():String
		{
			return hasData(TEXTURE_ATLAS_CONFIG_FILE_NAME)?getData(TEXTURE_ATLAS_CONFIG_FILE_NAME):GlobalConstValues.TEXTURE_ATLAS_DATA_NAME;
		}
		public function set textureAtlasConfigFileName(value:String):void
		{
			setData(TEXTURE_ATLAS_CONFIG_FILE_NAME, value);
		}
		
		public function get subTextureFolderName():String
		{
			return hasData(SUB_TEXTURE_FOLDER_NAME)?getData(SUB_TEXTURE_FOLDER_NAME):GlobalConstValues.TEXTURE_ATLAS_DATA_NAME;
		}
		public function set subTextureFolderName(value:String):void
		{
			setData(SUB_TEXTURE_FOLDER_NAME, value);
		}
		
		public function get userName():String
		{
			return hasData(USER_NAME)?getData(USER_NAME):"";
		}
		public function set userName(value:String):void
		{
			setData(USER_NAME, value);
		}
		
		public function get userEmail():String
		{
			return hasData(USERE_MAIL)?getData(USERE_MAIL):"";
		}
		public function set userEmail(value:String):void
		{
			setData(USERE_MAIL, value);
		}
		
		public function SettingManager()
		{
			if (_instance)
			{
				throw new IllegalOperationError("SettingManager class already constructed!");
			}
			_instance = this;
			init();
		}
		
		private function init():void
		{
			_shareObject = SharedObject.getLocal(SHARE_LOCAL, "/");
		}
		
		public function setImportVOValues(importVO:ImportVO):void
		{
			importVO.textureAtlasWidth = textureAtlasWidth;
			importVO.textureAtlasPadding = textureAtlasPadding;
			importVO.fadeInTime = importFadeInTime;
		}
		
		public function setExportVOValues(exportVO:ExportVO):void
		{
			exportVO.backgroundColor = exportBackgroundColor;
			exportVO.scale = exportScale;
			exportVO.textureAtlasPath = textureAtlasPath;
			exportVO.configType = exportDataFormatAC.source[exportDataFormatIndex].value;
			exportVO.textureAtlasType = exportTextureFormatAC.source[exportTextureFormatIndex].value;
			exportVO.dragonBonesFileName = dragonBonesFileName;
			exportVO.textureAtlasFileName = textureAtlasFileName;
			exportVO.textureAtlasConfigFileName = textureAtlasConfigFileName;
			exportVO.subTextureFolderName = subTextureFolderName;
		}
		
		/**
		 * Determine if key is exist
		 */
		public function hasData(key:String):Boolean
		{
			return Boolean(key in _shareObject.data);
		}
		
		/**
		 * Get data by key
		 */
		public function getData(key:String):*
		{
			return _shareObject.data[key];
		}
		
		/**
		 * Set data by key and value
		 */
		public function setData(key:String, value:*):void
		{
			if(_shareObject.data[key] != value)
			{
				_shareObject.data[key] = value;
				_shareObject.flush();
			}
		}
		
		private function updateLanguage():void
		{
			var i:int = 0;
			var currentLanguageID:int = languageIndex;
			ResourceManager.getInstance().localeChain = [languageAC[currentLanguageID].value];
			
			for each (var importTypeItem:Object in importTypeAC.source)
			{
				importTypeItem.label = ResourceManager.getInstance().getString('resources', String(importTypeItem.value)) || importTypeItem.value;
			}
			
			for each (var exportDataItem:Object in exportDataFormatAC.source)
			{
				exportDataItem.label = ResourceManager.getInstance().getString('resources', String(exportDataItem.value)) || exportDataItem.value;
			}
			
			for each (var exportTextureItem:Object in exportTextureFormatAC.source)
			{
				exportTextureItem.label = ResourceManager.getInstance().getString('resources', String(exportTextureItem.value)) || exportTextureItem.value;
			}
			
			for each (var exportTextureMergedItem:Object in exportTextureMergedFormatAC.source)
			{
				exportTextureMergedItem.label = ResourceManager.getInstance().getString('resources', String(exportTextureMergedItem.value)) || exportTextureMergedItem.value;
			}
		}
	}
}