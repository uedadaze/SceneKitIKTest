//
//  GameViewController.h
//  IKTest
//

//  Copyright (c) 2014年 Itsuki Ichikawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface GameViewController : UIViewController{
    SCNScene *scene;
    
    SCNIKConstraint *ik;
    
    SCNNode *arm;
    SCNNode *arm_root;
    SCNNode *arm_end;
    SCNNode *arm_A;
    SCNNode *arm_B;
}

@end
