#ifndef __TRANFORMATION_HISTORY_H
#define __TRANFORMATION_HISTORY_H

#include "RakNetTypes.h"
#include "DS_Queue.h"
#include "RakMemoryOverride.h"


struct TransformationHistoryCell
{
	TransformationHistoryCell();
	TransformationHistoryCell(RakNet::TimeMS t, float x, float y, int vx, int vy, int state);

	RakNet::TimeMS _time;
    
    int _x;
    int _y;
    
    int _velocityX;
    int _velocityY;
    
    int _state;
};

/// \brief This class stores a series of data points consisting of position, orientation, and velocity
/// Data points are written using Write(). The number of points stored is determined by the values passed to Init()
/// Points are read out using Read(). Read() will interpolate between two known points given a time between those points, or between the last known and current point.
/// For smooth interpolation, render entities by reading their past positions by whatever amount of time your update interval is.
class TransformationHistory
{
public:
	/// \brief Call to setup this class with required parameters
	/// maxWriteInterval should be equal to or less than the interval between updates for a given entity
	/// maxHistoryTime is the maximum amount of time you want to read in the past
	/// \param[in] maxWriteInterval Minimum amount of time that must elapse between new data points added with Write.
	/// \param[in] maxHistoryTime How long to store data points before they expire
	void Init(RakNet::TimeMS maxWriteInterval, RakNet::TimeMS maxHistoryTime);

	/// \brief Adds a new data point to the end of the queue
	/// If less than maxWriteInterval has elapsed since the last call, the Write() call is ignored.
	/// \param[in] position Position to write
	/// \param[in] velocity Velocity to write
	/// \param[in] orientation Orientation to write
	/// \param[in] curTimeMS Time when data point was generated, which should generally increment each call
	void Write(float x, float y, int vx, int vy, int state, RakNet::TimeMS curTimeMS);

	/// \brief Same as Write(), except that if the point is in the past, an older point updated
	void Overwrite(float x, float y, int vx, int vy, int state, RakNet::TimeMS when);

	enum ReadResult
	{
		// We are reading so far in the past there is no data yet
		READ_OLDEST,
		// We are not reading in the past, so the input parameters stay the same
		VALUES_UNCHANGED,
		// We are reading in the past
		INTERPOLATED
	};
	/// \brief Read an interpolated point in the psast
	/// Parameters are in/out, modified to reflect the history.
	/// \param[in/out] position As input, the current position of the object at \a curTime. As output, the position of the object at \when. Pass 0 to ignore.
	/// \param[in/out] velocity As input, the current velocity of the object at \a curTime. As output, the velocity of the object at \when. Pass 0 to ignore.
	/// \param[in/out] orientation As input, the current orientation of the object at \a curTime. As output, the orientation of the object at \when. Pass 0 to ignore.
	/// \param[in] when The time at which you want to read.
	/// \param[in] curTime Right now
	/// \return What method was used to calculate outputs
	ReadResult Read(float *x, float *y, int *vx, int *vy, int *state, RakNet::TimeMS when, RakNet::TimeMS curTime);

	/// \brief Clear all values in the history
	void Clear(void);
protected:
	DataStructures::Queue<TransformationHistoryCell> history;
	unsigned maxHistoryLength;
	RakNet::TimeMS writeInterval;
};

#endif
