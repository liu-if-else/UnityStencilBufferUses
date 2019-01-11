using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircleGenerator : MonoBehaviour {

    public GameObject prototype;
	// Use this for initialization
	void Start () {
        Vector3[] points=GenerateArchimedeanSpirals(100, new Vector3(100f, 100f, 100f), 3, 1, 1);
        foreach(Vector3 point in points){
            GameObject tempGO = GameObject.Instantiate(prototype, point, Quaternion.identity, null);
        }
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    public Vector3[] GenerateArchimedeanSpirals(int points, Vector3 centre, int circles, float a, float b)
    {

        Vector3[] coordinates = new Vector3[points];

        float radius;
        //调整角度的分配模式，circles为螺旋的圈数
        float theta = 2f * Mathf.PI / points * circles;
        for (int t = 0; t < points; t++)
        {
            //公式1
            radius = a + b * theta;
            //公式5   
            coordinates[t] = new Vector3(radius * Mathf.Cos(theta) + centre.x, radius * Mathf.Sin(theta) + centre.y, 0f);
            theta += 2f * Mathf.PI / points * circles;
        }
        return coordinates;
    }
}
