#import "FlutterMetalTexture.h"

#import <PlatformCDart/MetalDrawablePresenter.h>
#import <PlatformCDart/MetalLayerProvider.h>
#import <PlatformCDart/Util.h>

@interface MetalDrawablePresenterImpl : NSObject <MetalDrawablePresenter>

@property(nonatomic, weak) id<FlutterTextureRegistry> flutterTextureRegistry;
@property(nonatomic, assign) NSInteger flutterTextureId;

- (instancetype)initWithTextureRegistry:(id<FlutterTextureRegistry>)flutterTextureRegistry;
- (void)setFlutterTextureId:(NSInteger)textureId;

@end

@implementation MetalDrawablePresenterImpl

- (instancetype)initWithTextureRegistry:(id<FlutterTextureRegistry>)flutterTextureRegistry
{
	self = [super init];
	if (self)
	{
		_flutterTextureRegistry = flutterTextureRegistry;
	}
	return self;
}

- (void)setFlutterTextureId:(NSInteger)textureId
{
	_flutterTextureId = textureId;
}

- (void)present
{
	__strong id<FlutterTextureRegistry> registry = _flutterTextureRegistry;
	if (registry)
	{
		[registry textureFrameAvailable:_flutterTextureId];
	}
}

@end

@interface FlutterMetalTexture ()
@property(nonatomic, strong) MetalDrawablePresenterImpl * presenter;
@property(nonatomic, strong) MetalLayerProvider * metalLayerProvider;
@property(nonatomic, strong) id<FlutterTextureRegistry> flutterTextureRegistry;
@end

@implementation FlutterMetalTexture

- (instancetype)initWithDevice:(id<MTLDevice>)device
				  textureCache:(CVMetalTextureCacheRef)textureCache
		flutterTextureRegistry:(id<FlutterTextureRegistry>)flutterTextureRegistry
						 width:(NSInteger)width
						height:(NSInteger)height
{
	self = [super init];
	if (self)
	{
		_presenter = [[MetalDrawablePresenterImpl alloc] initWithTextureRegistry:flutterTextureRegistry];
		_metalLayerProvider = [[MetalLayerProvider alloc] initWithDevice:device
															textureCache:textureCache
															   presenter:_presenter
																   width:width
																  height:height];
		_flutterTextureRegistry = flutterTextureRegistry;
	}
	return self;
}

- (CVPixelBufferRef _Nullable)copyPixelBuffer
{
	return [_metalLayerProvider makePixelBuffer];
}

- (void)setMetalTextureToMapWithSurfaceId:(NSInteger)mapSurfaceId
						 flutterTextureId:(NSInteger)textureId
									width:(NSInteger)width
								   height:(NSInteger)height
{
	[_presenter setFlutterTextureId:textureId];
	dgis::dart::map::setMetalTextureToMap(
		mapSurfaceId,
		_metalLayerProvider,
		static_cast<unsigned>(width),
		static_cast<unsigned>(height));
}

@end
