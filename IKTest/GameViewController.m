//
//  GameViewController.m
//  IKTest
//
//  Created by 市川樹 on 2014/12/18.
//  Copyright (c) 2014年 Itsuki Ichikawa. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create a new scene
    SCNScene *scene = [SCNScene sceneNamed:@"TestArm.dae"];

    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 30);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    //　部位ごとのNodeの作成
    //　モデル全体
    SCNNode *arm = [scene.rootNode childNodeWithName:@"Arm" recursively:YES];
    //　モデルの根っこ
    SCNNode *arm_root = [arm childNodeWithName:@"RootBone" recursively:YES];
    //　モデルの末端
    SCNNode *arm_end = [arm childNodeWithName:@"BoneC" recursively:YES];
    
    //　モデルの各ノード
    arm_A = [arm childNodeWithName:@"BoneA" recursively:YES];
    arm_B = [arm childNodeWithName:@"BoneB" recursively:YES];
    
    //　SCNIKConstraint:IKの用意
    SCNIKConstraint *ik = [SCNIKConstraint inverseKinematicsConstraintWithChainRootNode:arm_root];
    //　モデルの末端に拘束条件として先ほど用意したIKを設定する
    arm_end.constraints = @[ik];
    ik.influenceFactor = 1.0;
    
    //　試しに動かしてみる
    [SCNTransaction begin];
    //　目標位置をSCNIKConstraintに与える
    ik.targetPosition = [scene.rootNode convertPosition:SCNVector3Make(1,-1,0) toNode:nil];
    
    [SCNTransaction commit];
    
    // animate the 3d object
    /*
    [arm runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    */
     
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
        
    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    
    
    NSLog(@"BoneA.rotate.x:%.2f", arm_A.presentationNode.eulerAngles.x);
    NSLog(@"BoneB.rotate.x:%.2f", arm_B.presentationNode.eulerAngles.x);
    
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
